# NOTES

## Main activities and client-server data flow

### User signup

* The user enters its username, password and additional data
* Client creates random asymmetric keys (public and secret) for this user
* Client encrypts user's secret key symmetrically using user's password
* The `accounts` package creates SRP validator from password
* User info (except password), SRP validator, user public key and encrypted secret keys are sent to server
* Server creates the user with provided data

### User login

* The user enters username and password
* The `accounts` package authenticates the user with SRP
* If the authentication fails, error and stop
* Server sends user's public key and encrypted secret key to client
* Client decrypts user's secret key symmetrically using user's password and keeps public and secret keys in memory

### Document creation

* User enters document title and content
* Client creates a random symmetric key for the document
* Client encrypts document content symmetrically using the key it just created
* Client encrypts the document key asymmetrically using the user's public key
* Client sends document title, encrypted document content and encrypted document key to server
* Server creates document with title and encrypted content, and binds it to the user id and encrypted document key

### Document read

* Server sends document title, encrypted document content and encrypted document key for this user to client
* Client decrypts document key asymmetrically using user's secret key
* Client decrypts document content asymmetrically using document key
* Client shows document title and content

### Document update

* User updates document title and/or content
* Client decrypts document key asymmetrically using user's secret key
* Client encrypts document content using document key
* Client sends updated document title and encrypted content to server
* Server updates document title and encrypted content

### Contact add

* User chooses another user by username
* Client sends other user id to server
* Server creates a contact between these users

### Document sharing

* User chooses a document and a contact to share it with
* Client asks server the public key of contact's user
* Server sends the requested public key
* Client decrypts document key asymmetrically using user's secret key
* Client encrypts document key asymmetrically using contact's public key
* Client sends contact id and encrypted document key to server
* Server binds document to contact's user id and encrypted document key

### Document un-sharing

TODO

### Contact removal

TODO