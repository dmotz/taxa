###
# Taxa
# A tiny runtime type-checking DSL
# 0.0.0
# Dan Motzenbecker
# http://oxism.com
# Copyright 2014, MIT License
###

libName = 'Taxa'

key =
  '0': 'null'
  a:   'array'
  b:   'boolean'
  f:   'function'
  n:   'number'
  o:   'object'
  s:   'string'
  u:   'undefined'

key[k.toUpperCase()] = v for own k, v of key


argSplit = ','
ioSplit  = ' '
orSplit  = '|'
optional = '?'
ignore   = '_'
suffixRx = /[^A-Z0-9]+$/i
reserved = Object.keys(key).concat optional, orSplit, ignore


taxa = (sig, fn) ->
  [i, o] = sig.split ioSplit
  i      = (parse s for s in i.split argSplit)
  o      = parse o

  shell = ->
    for def, n in i
      throw makeErr def, arguments[n], n unless verify def, arguments[n]

    result = fn.apply @, arguments
    throw makeErr o, result unless verify o, result
    result

  shell[k]     = v for k, v of fn
  shell.length = fn.length
  shell.name   = fn.name
  shell.bind   = ->
    i.shift() for a in Array::slice.call arguments, 1
    i.push [ignore: true] unless i.length
    Function::bind.apply shell, arguments

  shell


parse = (sig) ->
  types = sig.split orSplit
  for type in types
    suffixes = type.match(suffixRx)?[0] or ''

    type:     key[type] or type
    simple:   !!key[type]
    ignore:   type is ignore
    optional: optional in suffixes


verify = (def, val) ->
  for atom in def
    if atom.ignore
      return true

    if atom.type is 'null' and val is null
      return true

    if  atom.simple                                and
        (atom.type is key.a and Array.isArray val) or
        (typeof val is atom.type)                  or
        (atom.optional and typeof val is key.u)

      return true

    if !atom.simple and val?.constructor?.name is atom.type
      return true

  false


makeErr = (def, val, n) ->
  new Error "#{ libName }: Expected #{ (def.map (t) -> t.type).join ' or ' } as
    #{ if n? then 'argument ' +  n else 'return type' }, given
    #{ if def[0].simple then typeof val else val?.constructor?.name }
    #{ if val isnt undefined then '(' + val + ') ' else '' }instead."


taxa = taxa 's,f f', taxa


if module?.exports?
  module.exports = taxa
else
  @taxa = taxa

