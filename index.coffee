'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-initial-state')
IS = require 'initial-state'


MESSAGE_SCHEMA =
  type: 'object'
  properties:
    event:
      type: 'string'
      required: true
    value:
      type: 'string'
      required: true

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    bucket:
      type: 'string'
      required: true
    access_key:
      type: 'string'
      required: true

class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    payload = message.payload
    @bucket.push payload.event, payload.value

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    @options = options
    @createBucket options

  createBucket: (options) =>
    @bucket = IS.bucket options.bucket, options.access_key if options.access_key?


module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
