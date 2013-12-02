# publish dashboard documents
Meteor.publish "dashboardDocuments", (options) ->
  check @userId, Match.NotEmptyString
  check options,
    page: Match.PositiveInteger
    limit: Match.PositiveInteger
    sort: Match.Optional(Match.CollectionSort ["title", "createdAt", "modifiedAt"])

  self = this

  options.skip = (options.page - 1) * options.limit
  delete options.page

  options.fields =
    title: 1
    createdAt: 1
    modifiedAt: 1

  options.transform = (document) ->
    document.encryptedKey = document.keys[self.userId].encryptedKey
    delete document.keys

    document

  selector = {}
  selector["keys.#{@userId}"] =
      $exists: true

  Documents.find selector, options