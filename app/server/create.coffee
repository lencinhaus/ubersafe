Meteor.methods
  createDocument: (document, key) ->
    check @userId, Match.NotEmptyString

    check document,
      type: Match.InArray ["text"]
      title: Match.NotEmptyString
      content: Match.NotEmptyString

    check key, Match.NotEmptyString

    now = new Date()

    _.extend document,
      createdAt: now
      modifiedAt: now
      creatorUserId: @userId
      users: {}

    userData =
      key: key
      canEdit: true

    document.users[@userId] = userData

    Documents.insert document