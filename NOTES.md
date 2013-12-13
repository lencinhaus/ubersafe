# NOTES

## Data Model

### User

```
{
    _id: "xxx",
    username: "xxx",
    ubersafe: {
        keys: {
            public: "xxx",
            secretEncrypted: "yyy"
        }
    },
    ...
}
```

### Document

```
{
    _id: "xxx",
    type: "text",
    title: "title",
    content: "encrypted content",
    creatorUserId: "XXX"
    users: {
        "creatorUserId": {
            key: "encrypted key",
            canEdit: true,
            needsRekeying: false
        },
        "otherUserId": {
            key: "other encrypted key",
            canEdit: false,
            needsRekeying: true
        },
        ...
    }
}
```

### Contact

```
{
    _id: "xxx",
    fromUserId: "xxx",
    toUserId: "yyy",
    status: "requested|accepted|declined",
    ...
}

```

## Main activities and client-server data flow

### User signup

* The user enters its *username*, *password* and additional data
* Client creates random asymmetric keys (*public* and *secret*) for this user
* Client encrypts user's *secret key* symmetrically using user's *password*
* The `accounts` package creates *SRP validator* from *password*
* User info (except *password*), *SRP validator*, user *public* and encrypted *secret* keys are sent to server
* Server creates the user with provided data

### User login

* The user enters *username* and *password*
* The `accounts` package authenticates the user with *SRP*
* If the authentication fails, error and stop
* Server sends user's *public key* and encrypted *secret key* to client
* Client decrypts user's *secret key* symmetrically using user's *password* and keeps *public* and *secret* keys in memory

### Document creation

* User enters document *title* and *content*
* Client creates a random symmetric *key* for the document
* Client encrypts document *content* symmetrically using the *key* it just created
* Client encrypts the document *key* asymmetrically using the user's *public key*
* Client sends document *title*, encrypted document *content* and encrypted document *key* to server
* Server creates document with *title* and encrypted *content*, and binds it to the user *id* and encrypted document *key*
* The current user is and will always be the owner of this document

### Document read

* Server sends document *title*, encrypted document *content* and encrypted document *key* for this user to client
* Client decrypts document *key* asymmetrically using user's *secret key*
* Client decrypts document *content* asymmetrically using document *key*
* Client shows document *title* and *content*

### Document update

* User updates document *title* and *content*
* Client decrypts document *key* asymmetrically using user's *secret key*
* Client encrypts document *content* using document *key*
* Client sends updated document *title* and encrypted *content* to server
* Server updates document *title* and encrypted *content*

### Contact add

* User chooses another user by *username*
* Client sends other *user id* to server
* Server creates a contact between these users

### Document sharing

* User chooses a document which she is the owner of, and a contact to share it with
* Client asks server the *public key* of contact's user
* Server sends the requested *public key*
* Client decrypts the user's document *key* asymmetrically using user's *secret key*
* Client generates contact's encrypted document *key* by encrypting document *key* asymmetrically using contact's *public key*
* Client sends document *id*, contact *id* and contact's encrypted document *key* to server
* Server binds document to contact's *user id* and encrypted document *key*

### Document un-sharing

There are three actors involved in this process:

* The document's *owner*
* The contact that shares the document which has to be un-shared. We'll call him *un-shared contact*
* The other contacts that share the document, which will keep sharing it. We'll call them *other contacts*

The process is slightly different depending on whether it is initiated by the document *owner* or by one of his contacts.

#### Initiated by document owner

* *owner* requests that a document he has shared with *un-shared contact* is un-shared
* Client asks server the *public keys* of all *owner*'s contacts which the document is shared with, including *un-shared contact* and *other contacts*
* Server sends the requested *public keys*
* Client generates two new random symmetric *keys* for the document, one for *un-shared contact* and one for *owner* and *other contacts*
* Client encrypts document *content* symmetrically with new document *key* for *owner* and *other contacts*
* Client encrypts document *content* symmetrically with new document *key* for *un-shared contact*
* Client encrypts new document *key* for *owner* and *other contacts* asymmetrically with *owner*'s *public key*
* For each contact in *other contacts*, client encrypts new document *key* for *owner* and *other contacts* asymmetrically with *other contact*'s *public key*
* Client encrypts new document *key* for *un-shared contact* asymmetrically with *un-shared contact*'s *public key*
* Client sends the following data to the server:

> * *id* of document to be un-shared
> * *id* of *un-shared contact* (the owner is implicit with the document)
> * new encrypted document *key* for *owner*
> * new encrypted document *key* for *un-shared contact*
> * one new encrypted document *key* for each contact in *other contacts*
> * new encrypted document *content* for *owner* and *other contacts*
> * new encrypted document *content* for *un-shared contact*

* Server creates a new document for *un-shared contact* using the new provided encrypted document *content*.
* Server binds the new document for *un-shared contact* to *un-shared contact* using the provided encrypted document *key*, and marks it as "needing to be re-keyed"
* Server creates a new document for *owner* and *other contacts* using the new provided encrypted document *content*.
* Server binds the new document for *owner* to *owner* and each contact in *other contacts* using the provided encrypted document *keys*
* Server removes the original document

#### Initiated by document owner's contact

* *un-shared contact* requests that a document *owner* has shared with her is un-shared
* Client asks server the *public keys* of *owner* and *other contacts*
* Server sends the requested *public keys*
* Client generates two new random symmetric *keys* for the document, one for *un-shared contact* and one for *owner* and *other contacts*
* Client encrypts document *content* symmetrically with new document *key* for *owner* and *other contacts*
* Client encrypts document *content* symmetrically with new document *key* for *un-shared contact*
* Client encrypts new document *key* for *owner* and *other contacts* asymmetrically with *owner*'s *public key*
* For each contact in *other contacts*, client encrypts new document *key* for *owner* and *other contacts* asymmetrically with *other contact*'s *public key*
* Client encrypts new document *key* for *un-shared contact* asymmetrically with *un-shared contact*'s *public key*
* Client sends the following data to the server:

> * *id* of document to be un-shared
> * *id* of *un-shared contact* (the owner is implicit with the document)
> * new encrypted document *key* for *owner*
> * new encrypted document *key* for *un-shared contact*
> * one new encrypted document *key* for each contact in *other contacts*
> * new encrypted document *content* for *owner* and *other contacts*
> * new encrypted document *content* for *un-shared contact*

* Server creates a new document for *un-shared contact* using the new provided encrypted document *content*.
* Server binds the new document for *un-shared contact* to *un-shared contact* using the provided encrypted document *key*
* Server creates a new document for *owner* and *other contacts* using the new provided encrypted document *content*.
* Server binds the new document for *owner* to *owner* and each contact in *other contacts* using the provided encrypted document *keys*, and marks them as "needing to be re-keyed"
* Server removes the original document

### Contact removal

* User asks to remove one of her contacts
* Each *document* shared between the current user and the contact is un-shared. See the previous process for details about document un-sharing
* Client sends contact id to server
* Server removes contact