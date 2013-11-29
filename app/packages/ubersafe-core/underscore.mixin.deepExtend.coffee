# Create a deep copy of an object. - CoffeeScript conversion of @cederberg's deepClone implementation https://github.com/documentcloud/underscore/pull/595
deepClone = (obj) ->
  if !_.isObject(obj) or _.isFunction(obj) then return obj
  if _.isDate obj then return new Date do obj.getTime
  if _.isRegExp obj then return new RegExp obj.source, obj.toString().replace(/.*\//, "")

  isArr = _.isArray obj or _.isArguments obj

  func = (memo, value, key) ->
    if isArr then memo.push deepClone value
    else memo[key] = deepClone value
    return memo;
  return _.reduce obj, func, if isArr then [] else {}

# Is a given value a basic Object? i.e.: {} || new Object()
isBasicObject = (object) ->
  (object.prototype is {}.prototype or object.prototype is Object.prototype) and _.isObject(object) and not _.isArray(object) and not _.isFunction(object) and not _.isDate(object) and not _.isRegExp(object) and not _.isArguments(object)

# Returns a list of the names of every object in an object — that is to say, the name of every property of the object that is an object.
basicObjects = (object) ->
  _.filter _.keys(object), (key) -> isBasicObject object[key]

# Returns a list of the names of every array in an object — that is to say, the name of every property of the object that is an array.
arrays = (object) ->
  _.filter(_.keys(object), (key) -> _.isArray object[key])

# Copy and combine all of the properties in the source objects over to the destination object and return the destination object. This method will recursively copy shared properties which are also objects and combine arrays.
deepExtendCouple = (destination, source, maxDepth=20) ->
  if maxDepth <= 0
    console.warn '_.deepExtend(): Maximum depth of recursion hit.'
    return _.extend destination, source

  sharedObjectKeys = _.intersection(basicObjects(destination), basicObjects(source))
  recurse = (key) ->
    source[key] = deepExtendCouple destination[key], source[key], maxDepth-1

  recurse sharedObjectKey for sharedObjectKey in sharedObjectKeys

  sharedArrayKeys = _.intersection(arrays(destination), arrays(source))
  combine = (key) ->
    source[key] = _.union destination[key], source[key]

  combine sharedArrayKey for sharedArrayKey in sharedArrayKeys

  _.extend destination, source

# Copy and combine all of the properties in the supplied objects from right to left and return the combined object. This method will recursively copy shared properties which are also objects and combine arrays.
deepExtend = (objects..., maxDepth) ->
  if !_.isNumber maxDepth
    objects.push maxDepth
    maxDepth = 20

  if objects.length <= 1 then return objects[0]
  if maxDepth <= 0 then return _.extend.apply this, objects

  finalObj = do objects.shift
  while objects.length > 0
    finalObj = deepExtendCouple(finalObj, deepClone(do objects.shift), maxDepth)

  return finalObj

_.mixin
  deepClone: deepClone
  isBasicObject: isBasicObject
  basicObjects: basicObjects
  arrays: arrays
  deepExtend: deepExtend