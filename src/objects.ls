'use strict'

{ isType } = require './types'
{ curry }  = require './funcs'

_hasOwnProperty = Object.prototype.hasOwnProperty

# empty :: object -> boolean
export empty = (obj) ->
    for k of obj then return false
    true

# clone :: object -> object
export clone = (obj) ->
    deepMixin null, obj

# keys :: object -> [string]
export keys = (obj) ->
    [k for k of obj]

# values :: object -> [any]
export values = (obj) ->
    [v for , v of obj]

# each :: function -> object -> object
export each = curry (f, obj) ->
    for k, v of obj then (f v, k)
    obj

# map :: function -> object -> object
export map = curry (f, obj) ->
    {[k, (f v, k)] for k, v of obj}

# filter :: function -> object -> object
export filter = curry (f, object) ->
    {[k, v] for k, v of object when (f v, k)}

# partition :: function -> object -> [object]
export partition = curry (f, object) ->
    passed = {}
    failed = {}
    for k, v of object
        (if (f v, k) then passed else failed)[k] = v
    [passed, failed]

# keyOf :: any -> object -> string
export keyOf = curry (elem, obj) ->
    for k, v of obj
    when v is elem
        return k
    void

# keysOf :: any -> object -> string
export keysOf = curry (elem, obj) ->
    [k for k, v in obj when v is elem]

# findKey :: function -> object -> string
export findKey = curry (f, obj) ->
    for k, v of obj when (f v, k)
        return k
    void

# findKeys :: function -> object -> [string]
export findKeys = curry (f, obj) ->
    [k for k, v in obj when (f v, k)]

# fromPairs :: array -> object
export fromPairs = (xs) ->
    {[x.0, x.1] for x in xs}

# toPairs :: object -> array
export toPairs = (obj) ->
    [[key, value] for key, value of obj]

# hasOwnProperty :: string -> object -> boolean
export hasOwnProperty = curry (key, obj) ->
    _hasOwnProperty.call obj, key

# mixin :: object -> ...object -> object
export mixin = (dest = {}, ...sources) ->
    for src in sources then
        for key, val of src then
            dest[key] = val
    dest

# deepMixin :: object -> ...object -> object
export deepMixin = (dest = {}, ...sources) ->
    for src in sources then
        for k, v of src then
            if (isType 'Object' dest[k]) and (isType 'Object' v)
            then dest[k] = deepMixin dest[k], v
            else dest[k] = v
    dest

# fill :: object -> ...object -> object
export fill = (dest, ...sources) ->
    for src in sources
        for k, v of src
        when dest[k] is void
            dest[k] = v
    dest

# deepFill :: object -> ...object -> object
export deepFill = (dest, ...sources) ->
    for src in sources then
        for k, v of src
        when dest[k] is void
            if (isType 'Object' dest[key]) and (isType 'Object' v)
            then dest[k] = deepFill dest[k], v
            else dest[k] = v
    dest

# freeze :: object -> object
export freeze = (obj) ->
    Object.freeze obj

# deepFreeze :: object -> object
export deepFreeze = (obj) ->
    Object.freeze obj unless Object.isFrozen obj
    for key, value of obj
    when (hasOwnProperty key, obj) and (isType value) is 'Object'
        deepFreeze value
    obj

# toString :: object -> string
export toString = (obj) -> JSON.stringify obj

# parseString :: object -> string
export parseString = curry (n, f, obj) -> JSON.stringify obj, f, 2

# fromString :: string -> object
export fromString = (obj) -> JSON.parse obj