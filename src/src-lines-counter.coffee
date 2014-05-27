fs = require 'fs'

sourceLinesCounter = (path) ->
    ret = {fileNum: 0, lines: 0}
    countFiles = []

    stats = fs.statSync path
    if stats.isFile()
        ret.fileNum = 1
        ret.lines = count path
        return ret

    walk path, countFiles

    for file in countFiles
        ret.lines += file.lines
        ret.fileNum++

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
            resultArray.push { fileName: file, lines: count fullPath }

count = (path, rules) ->
    try
        content = fs.readFileSync path, {encoding: 'utf-8'}
    catch e
        'can not read :' + path + e

    lines = content.split '\n'
    counter = 0    
    wordsReg = /\w/
    inlineCommentReg = rules?.inlineComment || /^\s*\/\//
    blockCommentStartReg = rules?.blockCommentStart || /\s*(\S*)\s*(\/\*)\s*/
    blockCommentEndReg = rules?.blockCommentEnd || /(\*\/)\s*(\w)*\s*$/
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

module.exports = sourceLinesCounter