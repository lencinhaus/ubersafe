# publish viewed document
Meteor.publish "viewDocument", (documentId) ->
  unless @userId then null

  check @userId, Match.NotEmptyString
  check documentId, Match.NotEmptyString

  selector =
    _id: documentId
  selector["users.#{@userId}"] =
    $exists: true

  fields =
    title: 1
    content: 1
  fields["users.#{@userId}"] = 1

  Documents.find selector,
    fields: fields