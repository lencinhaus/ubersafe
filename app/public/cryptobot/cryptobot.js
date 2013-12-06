/**
 * CryptoBot is a Web Worker that encrypts/decrypts stuff in background
 */

// constants
CIPHER_MODE = 'gcm';
CIPHER_TAG_SIZE = 128;

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
        var ciphertext = encryptString(data.plaintext, data.key, data.iv);
        returnResult(ciphertext);
        break;
      case 'decryptString':
        var plaintext = decryptString(data.ciphertext, data.key, data.iv);
        returnResult(plaintext);
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

function createCipher(key) {
  return new sjcl.cipher.aes(key);
}

function encryptString(plaintext, key, iv) {
  plaintext = sjcl.codec.utf8String.toBits(plaintext);
  var ciphertext = sjcl.mode[CIPHER_MODE].encrypt(createCipher(key), plaintext, iv, [], CIPHER_TAG_SIZE);
  return sjcl.codec.base64.fromBits(ciphertext);
}

function decryptString(ciphertext, key, iv) {
  ciphertext = sjcl.codec.base64.toBits(ciphertext);
  var plaintext = sjcl.mode[CIPHER_MODE].decrypt(createCipher(key), ciphertext, iv, [], CIPHER_TAG_SIZE);
  return sjcl.codec.utf8String.fromBits(plaintext);
}