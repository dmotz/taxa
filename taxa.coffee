###
# Taxa
# A tiny runtime typing DSL
# 0.0.0
# Dan Motzenbecker
# http://oxism.com
# Copyright 2014, MIT License
###

libName = 'Taxa'

key =
  N:   'number'
  B:   'boolean'
  S:   'string'
  F:   'function'
  O:   'object'
  A:   'array'
  U:   'undefined'
  '0': 'null'

key[k.toLowerCase()] = v for own k, v of key


argSplit = ','
ioSplit  = ' '
orSplit  = '|'
optional = '?'
ignore   = '_'
strict   = '!'
suffixRx = /[^A-Z0-9]+$/i
reserved = Object.keys(key).concat optional, orSplit, ignore


parse = (sig) ->
  types = sig.split orSplit
  for type in types
    suffixes = type.match(suffixRx)?[0] or ''
    type:     key[type] or type
    optional: optional in suffixes
    simple:   !!key[type] or true
    ignore:   type is ignore
    strict:   strict in suffixes


verify = (def, inst) ->
  for type in def

    if type.ignore

      return true

    if type.simple and
      (type.type is key.a and Array.isArray inst) or
      typeof inst is type.type or
      (type.optional and typeof inst is key.u)

      return true

  false


taxa = (sig, fn) ->
  [i, o] = sig.split ioSplit
  i      = (parse s for s in i.split argSplit)
  o      = parse o

  shell = ->
    for def, n in i
      unless verify def, arguments[n]
        throw new Error "#{ libName }: Expected #{ (def.map (t) -> t.type).join ' or ' }
          as argument #{ n }, given #{ typeof arguments[n] } (#{ arguments[n] }) instead."

    result = fn.apply @, arguments

    unless verify o, result
      throw new Error "#{ libName }: Expected #{ o.type } as return type,
        given #{ typeof result } (#{ result }) instead."

    result

  shell[k]     = v for k, v of fn
  shell.length = fn.length
  shell.name   = fn.name
  shell.bind   = ->
    i.shift() for a in Array::slice.call arguments, 1
    i.push [ignore: true] unless i.length

    Function::bind.apply shell, arguments

  shell


taxa = taxa 's,f f', taxa


if module?.exports?
  module.exports = taxa
else
  @taxa = taxa

