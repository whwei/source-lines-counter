assert = require 'assert'
slc = require '../lib/src-lines-counter.js'

retTest = slc './test/resource/test.js'

assert.equal retTest.files.length, 1
assert.equal retTest.totalLines, 2


retTest2 = slc './test/resource/test2.js'

assert.equal retTest2.files.length, 1
assert.equal retTest2.totalLines, 8

retResource = slc ['./test/resource/test.js', './test/resource/test2.js']

assert.equal retResource.files.length, 2
assert.equal retResource.totalLines, 10


