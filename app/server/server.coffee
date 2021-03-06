Future = Npm.require "fibers/future"

# add synthetic latency to a function call, for remote server simulation
@maybeWait = () ->
  if Meteor.settings.simulatedLatency <= 0 then return

  future = new Future

  delayed = ->
    future.return()

    return

  Meteor.setTimeout delayed, Meteor.settings.simulatedLatency

  future.wait()

# match patterns
_.extend Match,
  NotEmptyString: Match.Where (str) ->
    check str, String
    return str.trim().length > 0

  PositiveInteger: Match.Where (num) ->
    check num, Match.Integer
    return num >= 1

  InArray: (array) ->
    Match.Where (val) ->
      _.indexOf array, val isnt -1

  CollectionSortDirection: Match.Where (dir) ->
    1 is dir or -1 is dir

  CollectionSort: (sortableFields) ->
    matchObject = {}
    _.each sortableFields, (field) ->
      matchObject[field] = Match.Optional Match.CollectionSortDirection

    matchObject

# accept ubersafe params during user creation
Accounts.onCreateUser (options, user) ->
  if options.ubersafe
    user.ubersafe = options.ubersafe

  user

# publish ubersafe user properties
Meteor.publish "userUberSafeData", ->
  unless @userId then null

  maybeWait()

  Meteor.users.find @userId,
    fields:
      ubersafe: 1
