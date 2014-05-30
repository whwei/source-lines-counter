assert = require 'assert'
should = require('chai').should()

slc = require '../lib/src-lines-counter.js'

describe 'count source lines', ->
    it 'should work', -> 
        retTest = slc './test/resource/test.js'

        retTest.files.length.should.be.eql 1
        retTest.totalLines.should.be.eql 2


        retTest2 = slc './test/resource/test2.js'

        retTest2.files.length.should.be.eql 1
        retTest2.totalLines.should.be.eql 8

        retResource = slc ['./test/resource/test.js', './test/resource/test2.js']

        retResource.files.length.should.be.eql 2
        retResource.totalLines.should.be.eql 10


