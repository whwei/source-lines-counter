fs = require 'fs'

sourceLinesCounter = (path) ->
    
    ret = {files: [], totalLines: 0}
    
    paths = path
    paths = [path] if Array.isArray(path) isnt true

    for path in paths
        countFiles = []
        stats = fs.statSync path
        if stats.isFile()
            lines = count path
            ret.totalLines += lines
            ret.files.push { fileName: path, lines: lines}
            continue

        walk path, countFiles

        for file in countFiles
            ret.totalLines += file.lines
            ret.files.push(file)
    ret

walk = (path, resultArray) ->
    try
        files = fs.readdirSync path
    catch error
        'path error' + error
    
    for file in files
        fullPath = path + '/' + file
        stats = fs.statSync fullPath
        if stats.isDirectory()
            walk fullPath, resultArray
        else
            ext = fullPath.match /.*(\..*)$/
            type = ext[1] if ext isnt null and ext[1] isnt null
            if not extConfig[type]
                continue

            resultArray.push { fileName: fullPath, lines: count fullPath }

count = (path) ->
    try
        content = fs.readFileSync path, {encoding: 'utf-8'}
    catch e
        'can not read :' + path + e

    # check type
    ext = path.match /.*(\..*)$/
    type = ext[1] if ext isnt null and ext[1] isnt null
    type = '.js' if not extConfig[type]

    lines = content.split '\n'
    counter = 0
    wordsReg = extConfig[type].wordsReg
    inlineCommentReg =  extConfig[type].inlineCommentReg
    blockCommentStartReg = extConfig[type].blockCommentStartReg
    blockCommentEndReg = extConfig[type].blockCommentEndReg
    
    commentStart = false;

    for line in lines
        isCount = false
        
        # inside a comment
        if commentStart
            continue
        
        # inline comments
        c = line.match inlineCommentReg
        if c isnt null then continue

        # block comments start
        cs = line.match blockCommentStartReg 
        if cs and cs[1]
            commentStart = true
        else if cs and not cs[1]
            continue

        # block comments end
        ce = line.match blockCommentEndReg
        if ce and ce[2]
            commentStart = false;
        else if ce and not ce[2]
            continue

        if line.match wordsReg
            isCount = true

        counter += 1 if isCount is true

    counter

extConfig = 
    '.js': 
        wordsReg: /\w/
        inlineCommentReg: /^\s*\/\//
        blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
        blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
    '.java':
        wordsReg: /\w/
        inlineCommentReg: /^\s*\/\//
        blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
        blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
    '.css':
        wordsReg: /\w/
        inlineCommentReg: /^\s*\/\//
        blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
        blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
    '.coffee':
        wordsReg: /\w/
        inlineCommentReg: /^\s*\/\//
        blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
        blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
    '.html':
        wordsReg: /\w/
        inlineCommentReg: /^\s*\/\//
        blockCommentStartReg: /\s*(\S*)\s*(<!--)\s*/
        blockCommentEndReg: /(-->)\s*(\w)*\s*$/
    


module.exports = sourceLinesCounter