assert = require 'assert'
should = require('chai').should()

slc = require '../lib/src-lines-counter.js'

describe 'count source lines', ->
    it 'should work', -> 
        cfg =   
            js: 
                wordsReg: /\w/
                inlineCommentReg: /^\s*\/\//
                blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
                blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
            java:
                wordsReg: /\w/
                inlineCommentReg: /^\s*\/\//
                blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
                blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
            css:
                wordsReg: /\w/
                inlineCommentReg: /^\s*\/\//
                blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
                blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
            coffee:
                wordsReg: /\w/
                inlineCommentReg: /^\s*\/\//
                blockCommentStartReg: /\s*(\S*)\s*(\/\*)\s*/
                blockCommentEndReg: /(\*\/)\s*(\w)*\s*$/
            html:
                wordsReg: /\w/
                inlineCommentReg: /^\s*\/\//
                blockCommentStartReg: /\s*(\S*)\s*(<!--)\s*/
                blockCommentEndReg: /(-->)\s*(\w)*\s*$/

        retTest = slc './test/resource/test.js', cfg

        retTest.files.length.should.be.eql 1
        retTest.totalLines.should.be.eql 2


        retTest2 = slc './test/resource/test2.js'

        retTest2.files.length.should.be.eql 1
        retTest2.totalLines.should.be.eql 8

        retResource = slc ['./test/resource/test.js', './test/resource/test2.js']

        retResource.files.length.should.be.eql 2
        retResource.totalLines.should.be.eql 10


