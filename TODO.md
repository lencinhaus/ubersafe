TODO
====

## Dependencies to be removed

* flash-messages: we already use a custom handlebars helper, so we could use an internal implementation and drop this package

## Signed browser extension

* For security reasons, the client will only be used as a singed browser extension. This must be done because client code cannot be delivered in a safe way from an untrusted server, which is UberSafe's case, even on HTTPS. The server is not trusted because user data must be safe (un-decryptable) even if the server is compromised.
* The application can still be run as usual for development
* We must build a script for building the deployable app, that does the following:
    * Bundle the app with `demeteorizer`
    * From the complete bundle, create the server bundle, disabling all static file serving and only leaving DDP over WebSockets. Must find a way to keep `livedata` functionality while disabling `webapp`.
    * Create the client stub for the browser extension, by extracting all the files needed on the client (`index.html`, javascript and css). [packmeteor](https://npmjs.org/package/packmeteor) might be a good starting point.
    * Create the singed extensions for each browser by completing the client stub with the additional files needed for that browser, and sign them. Guides for specific browsers are here:
        * [Chrome](http://developer.chrome.com/extensions/packaging.html)
        * [Firefox](https://developer.mozilla.org/en-US/docs/Signing_an_extension)
        * [Safari](https://developer.apple.com/library/safari/documentation/Tools/Conceptual/SafariExtensionGuide/Introduction/Introduction.html)
* For Firefox and Safari, a code-signing certificate is needed, and since it costs a lot, we'll build only the chrome extension at first.

## File upload

* Right now UberSafe only allows management of textual documents with markdown syntax. In the future we'd like to allow file uploads too.
* File upload:
    * Files must be encrypted before being sent to the server, and for this to be practical it must be done in a completely streamed fashion.
    * On the client, we can use the new HTML5 FileReader API where supported, see below
    * The local file is read in chunks. Each chunk is sent to cryptobot for encryption
    * Once cryptobot has encrypted the chunk, it returns it to the main thread, where it is sent to the server using a Meteor method
    * The server stores the chunks sequentially in the Mongo db using the GridStore functionality, see below for details.
* File download:
    * When the user wants to download a file, chunks are sent from the server.
    * Each chunk is decrypted in cryptobot and written to a temporary, sandboxed file, using the FileSystem api (specifically `FileWriter` or `FileWriterSync` in a Worker)
    * Once all the chunks have been written, the file should be complete, so the client can redirect the user to the url of the local file, which she can download quickly. Still have to understand if this is feasible.
* It might be the case to store all document contents (markdown ones too) in GridFS, since it would make the API and code more simple and general.
* Documents about the FileSystem and File APIs and support:
    * http://caniuse.com/#feat=filesystem
    * http://caniuse.com/#feat=filereader
    * http://www.w3.org/TR/file-system-api/
    * http://www.w3.org/TR/FileAPI/
    * http://www.html5rocks.com/en/tutorials/file/filesystem/
    * http://docs.webplatform.org/wiki/apis/filesystem
    * http://docs.webplatform.org/wiki/apis/file
* Documents about MongoDB GridFS:
    * http://docs.mongodb.org/manual/core/gridfs/
    * http://mongodb.github.io/node-mongodb-native/api-generated/grid.html
    * http://mongodb.github.io/node-mongodb-native/api-generated/gridstore.html

## Document re-keying

* Background loop that re-keys documents that need to be re-keyed

## Dashboard

* Mark documents that need to be / are being re-keyed, maybe showing a percentage

## Contacts

* Show a modal with shared documents when an accepted contact is clicked
* Correct the "Remove" buttons confirm message with the actual flow and consequences of removing a contact, see NOTES.md

## Signup

* Enforce multi-factor password strength: min/max length, min number of uppercase, lowercase, numbers and punctuation. All these thresholds should be configurable in `Meteor.settings`.
* A popover showing which password requirements have/haven't been met would be nice.


