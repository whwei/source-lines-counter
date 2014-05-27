assert = require 'assert'
slc = require '../lib/src-lines-counter.js'

retTest = slc './test/resource/test.js'

assert.equal retTest.fileNum, 1
assert.equal retTest.lines, 2


retTest2 = slc './test/resource/test2.js'

assert.equal retTest2.fileNum, 1
assert.equal retTest2.lines, 8

retResource = slc './test/resource'

assert.equal retResource.fileNum, 2
assert.equal retResource.lines, 10

