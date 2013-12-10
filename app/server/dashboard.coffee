# publish dashboard documents
Meteor.publish "dashboardDocuments", (options) ->
  maybeWait()

  unless @userId then null

  check @userId, Match.NotEmptyString
  check options,
    page: Match.PositiveInteger
    limit: Match.PositiveInteger
    sort: Match.Optional(Match.CollectionSort ["title", "createdAt", "modifiedAt"])

  options.skip = (options.page - 1) * options.limit
  delete options.page

  options.fields =
    title: 1
    createdAt: 1
    modifiedAt: 1

  selector = {}
  selector["users.#{@userId}"] =
      $exists: true

  Documents.find selector, options