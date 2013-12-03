Meteor.methods
  createDocument: (document, encryptedKey) ->
    check @userId, Match.NotEmptyString
    check document,
      type: Match.InArray ["text"]
      title: Match.NotEmptyString
      encryptedContent: Match.NotEmptyString

    check encryptedKey, Match.NotEmptyString

    now = new Date()

    _.extend document,
      createdAt: now
      modifiedAt: now
      creatorUserId: @userId
      keys: {}

    document.keys[@userId] =
      encryptedKey: encryptedKey
      canEdit: true

    Documents.insert document