/**
 * CryptoBot is a Web Worker that encrypts/decrypts stuff in background
 */

// hack for preventing a "window is not defined" error from sjcl init
window = null;

// load libraries
importScripts('sjcl.min.js');

// set paranoia to zero
// client will add entropy, but we can't risk that the prng is not ready when we need it
sjcl.random.setDefaultParanoia(0, 'Setting paranoia=0 will ruin your security; use it only for testing');

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