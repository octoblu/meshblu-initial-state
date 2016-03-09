'use strict';
util           = require 'util'
{EventEmitter} = require 'events'
debug          = require('debug')('meshblu-initial-state')
IS             = require 'initial-state'
_              = require 'lodash'


MESSAGE_SCHEMA =
  type: 'object'
  properties:
    bucket:
      type: 'string'
      required: true
    event:
      type: 'string'
      required: true
    value:
      type: 'string'
      required: true

OPTIONS_SCHEMA =
  type: 'object'
  properties:
    access_key:
      type: 'string'
      required: true
    bucket:
      type: 'array'
      items:
        type: "string"


class Plugin extends EventEmitter
  constructor: ->
    @options = {}
    @bucket = {}
    @messageSchema = MESSAGE_SCHEMA
    @optionsSchema = OPTIONS_SCHEMA

  onMessage: (message) =>
    payload = message.payload
    @bucket[payload.bucket].push payload.event, payload.value

  onConfig: (device) =>
    @setOptions device.options

  setOptions: (options={}) =>
    if !_.isEqual @options, options
      @options = options
      @createBucket()


  createBucket: () =>
    self = @
    if self.options.bucket?
      _.forEach self.options.bucket, (new_bucket) ->
        if !self.bucket[new_bucket]?
          self.bucket[new_bucket] = IS.bucket new_bucket, self.options.access_key if self.options.access_key?
     MESSAGE_SCHEMA.properties.bucket.enum = self.options.bucket
     self.emit 'update', {messageSchema: MESSAGE_SCHEMA}




module.exports =
  messageSchema: MESSAGE_SCHEMA
  optionsSchema: OPTIONS_SCHEMA
  Plugin: Plugin
