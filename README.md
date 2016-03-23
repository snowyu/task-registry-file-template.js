## task-registry-file-template [![npm](https://img.shields.io/npm/v/task-registry-file-template.svg)](https://npmjs.org/package/task-registry-file-template)

[![Build Status](https://img.shields.io/travis/snowyu/task-registry-file-template.js/master.svg)](http://travis-ci.org/snowyu/task-registry-file-template.js)
[![Code Climate](https://codeclimate.com/github/snowyu/task-registry-file-template.js/badges/gpa.svg)](https://codeclimate.com/github/snowyu/task-registry-file-template.js)
[![Test Coverage](https://codeclimate.com/github/snowyu/task-registry-file-template.js/badges/coverage.svg)](https://codeclimate.com/github/snowyu/task-registry-file-template.js/coverage)
[![downloads](https://img.shields.io/npm/dm/task-registry-file-template.svg)](https://npmjs.org/package/task-registry-file-template)
[![license](https://img.shields.io/npm/l/task-registry-file-template.svg)](https://npmjs.org/package/task-registry-file-template)


Apply the configuration data to the file contents(treat it as the template).
It can specify a [template engine][task-registry-template-engine]. The default
template engine will be apply if no specified.

## Usage

```coffee
Task    = require 'task-registry'
require 'task-registry-file-template'

template = Task 'template'

###
hi.md:
the file path is '#{path}'.
#{hi}
###
template.executeSync path: 'hi.md', engine: 'Lodash', hi: 'hello world.'
###
the file path is 'hi.md'.
hello world.
###
```

## API

* `executeSync(aFile)` or `execute(aFile, done)`:
  * the `aFile` should be a json object or the [File][file] object.
    * `path` *String*: the file path
    * `engine` *String|Object*: the [template engine][[task-registry-template-engine]]

## TODO


## License

MIT


[task-registry-template-engine]:https://github.com/snowyu/task-registry-template-engine.js
[file]:https://github.com/snowyu/abstract-file.js