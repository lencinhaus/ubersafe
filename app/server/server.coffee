Meteor.startup ->
#  Meteor.users.remove {}

# accept ubersafe params during user creation
Accounts.onCreateUser (options, user) ->
  if options.ubersafe
    user.ubersafe = options.ubersafe

  user

# publish ubersafe user properties
Meteor.publish "userUberSafeData", ->
  unless @userId then null

  Meteor.users.find @userId,
    fields:
      ubersafe: 1

# publish user documents
