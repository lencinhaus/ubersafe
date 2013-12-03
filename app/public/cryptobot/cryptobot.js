/**
 * CryptoBot is a Web Worker that encrypts/decrypts stuff in background
 */

// load libraries
importScripts('sjcl.min.js');

// listen for commands
addEventListener('message', function(e) {
  var data = e.data;
  try {
    switch(data.command) {
      case 'addEntropy':
        var args = data.args;
        sjcl.random.addEntropy.apply(sjcl.random, args);
        break;
      case 'encryptString':
        var str = data.string;
        var encrypted = encryptString(str);
        returnResult(encrypted);
        break;
      default:
        returnError('unrecognized command ' + data.command);
        break;
    }
  }
  catch(error) {
    if('string' != typeof error) error = JSON.stringify(error);
    returnError(error);
  }
}, false);

function returnResult(result) {
  postMessage({
    type: 'result',
    result: result
  });
}

function returnError(error) {
  postMessage({
    type: 'error',
    error: error
  });
}

function log(message) {
  postMessage({
    type: 'log',
    message: message
  });
}

function encryptString(str) {
  log('encrypting string');
  if(Math.random() > .5) throw 'ERRORZS!';
  return 'ciphertexts';
}