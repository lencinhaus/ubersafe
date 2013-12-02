# publish viewed document
Meteor.publish "viewDocument", (documentId) ->
  unless @userId then null

  check @userId, Match.NotEmptyString
  check documentId, Match.NotEmptyString

  selector =
    _id: documentId
  selector["keys.#{@userId}"] =
    $exists: true

  Documents.find selector