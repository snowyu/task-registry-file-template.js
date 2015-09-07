fs              = require 'graceful-fs'
isFunction      = require 'util-ex/lib/is/type/function'
extend          = require 'util-ex/lib/_extend'
TemplateEngine  = require 'task-registry-template-engine'
Task            = require 'task-registry-resource'
register        = Task.register
aliases         = Task.aliases
defineProperties= Task.defineProperties

MISSING_OPTIONS = 'missing path'

# render the file contents with the specified template engine.
###
template:
  engine: String|Object
    name: the engine name
    ... : the options for the template engine
###
module.exports  = class TemplateFileTask
  register TemplateFileTask
  aliases TemplateFileTask, 'Template', 'template'

  templateEngine = TemplateEngine()

  defineProperties TemplateFileTask,
    engine: #the default template engine
      type: ['String', 'Object']

  constructor: ->return super

  _templateFilecallback: (aFile, done)->
    (err, contents)->
      ### !pragma coverage-skip-next ###
      return done err if err
      vEngine = extend {}, aFile.engine
      vEngine.template = contents
      vEngine.data = aFile
      templateEngine.execute vEngine, (err, result)->
        if !err and result and aFile.contents
          vCfg = if aFile.skipSize then aFile.contents.toString().slice(0, aFile.skipSize) else ''
          aFile.contents = vCfg+result
        done(err, result)

  _executeSync: (aFile)->
    if aFile.path?
      vEngine = extend {}, aFile.engine
      if isFunction aFile.getContentSync
        contents = aFile.getContentSync text:true
      else
        encoding = aFile.encoding
        encoding ?= 'utf8'
        contents = fs.readFileSync aFile.path, encoding:encoding
      vEngine.template = contents
      vEngine.data = aFile
      result = templateEngine.executeSync vEngine
      if result and aFile.contents
        vCfg = if aFile.skipSize then aFile.contents.toString().slice(0, aFile.skipSize) else ''
        aFile.contents = vCfg + result
    else
      throw new TypeError MISSING_OPTIONS
    result

  _execute: (aFile, done)->
    if aFile.path?
      if isFunction(aFile.getContent)
        aFile.getContent text:true, @_templateFilecallback(aFile, done)
      else
        encoding = aFile.encoding
        encoding ?= 'utf8'
        fs.readFile aFile.path, encoding:encoding, @_templateFilecallback(aFile, done)
    else
      done new TypeError MISSING_OPTIONS
