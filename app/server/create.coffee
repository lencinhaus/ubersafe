Meteor.methods
  createDocument: (title, encryptedContent, encryptedKey) ->
    check @userId, Match.NotEmptyString
    check title, Match.NotEmptyString
    check encryptedContent, Match.NotEmptyString
    check encryptedKey, Match.NotEmptyString

    now = new Date()

    document =
      title: title
      encryptedContent: encryptedContent
      createdAt: now
      modifiedAt: now
      creatorUserId: @userId
      keys: {}

    document.keys[@userId] =
      encryptedKey: encryptedKey
      canEdit: true

    Documents.insert document