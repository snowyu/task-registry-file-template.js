chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

setImmediate    = setImmediate || process.nextTick

TemplateFile    = require '../src'
Resource        = require 'resource-file'
fs              = require 'graceful-fs'
require 'task-registry-template-engine-lodash'

fs.cwd = process.cwd
fs.path = require 'path.js'
Resource.setFileSystem fs

describe 'TemplateFileTask', ->
  task = TemplateFile()

  describe 'executeSync', ->
    it 'should render a file contents via object', ->
      file = Resource './fixture/src.md', cwd:__dirname
      result = task.executeSync file
      expect(result).to.be.equal """
      # this is a pretty title

      你好 Riceball Riceball.
      """
      expect(file.contents).to.be.equal """
      ---
      title: this is a pretty title
      author: Riceball
      ---
      # this is a pretty title

      你好 Riceball Riceball.
      """

    it 'should render a file contents via object without front-matter', ->
      file = Resource './fixture/src1.md', cwd:__dirname
      file.title = 'this is a pretty title'
      file.author = 'Riceball'
      result = task.executeSync file
      expect(result).to.be.equal """
      # this is a pretty title

      你好 Riceball Riceball.
      """
      expect(file.contents).to.be.equal """
      # this is a pretty title

      你好 Riceball Riceball.
      """

    it 'should render a file contents via a file path', ->
      file =
        path: __dirname + '/fixture/src.md'
        title: 'this is a pretty title'
        author: 'Riceball'
      result = task.executeSync file
      expect(result).to.be.equal """
      ---
      title: this is a pretty title
      author: Riceball
      ---
      # this is a pretty title

      你好 Riceball Riceball.
      """
    it 'should throw error if no file path', ->
      expect(task.executeSync.bind(task, {})).to.throw 'missing'

  describe 'execute', ->
    it 'should render a file contents via object', (done)->
      file = Resource './fixture/src.md', cwd:__dirname
      task.execute file, (err, result)->
        unless err
          expect(result).to.be.equal """
          # this is a pretty title

          你好 Riceball Riceball.
          """
          expect(file.contents).to.be.equal """
          ---
          title: this is a pretty title
          author: Riceball
          ---
          # this is a pretty title

          你好 Riceball Riceball.
          """
        done(err)

    it 'should render a file contents via object without front-matter', (done)->
      file = Resource './fixture/src1.md', cwd:__dirname
      file.title = 'this is a pretty title'
      file.author = 'Riceball'
      task.execute file, (err, result)->
        unless err
          expect(result).to.be.equal """
          # this is a pretty title

          你好 Riceball Riceball.
          """
          expect(file.contents).to.be.equal """
          # this is a pretty title

          你好 Riceball Riceball.
          """
        done(err)

    it 'should render a file contents via a file path', (done)->
      file =
        path: __dirname + '/fixture/src.md'
        title: 'this is a pretty title'
        author: 'Riceball'
      result = task.execute file, (err, result)->
        unless err
          expect(result).to.be.equal """
          ---
          title: this is a pretty title
          author: Riceball
          ---
          # this is a pretty title

          你好 Riceball Riceball.
          """
        done(err)
    it 'should throw error if no file path', (done)->
      task.execute {}, (err, result)->
        expect(err).to.be.instanceOf TypeError
        done()
