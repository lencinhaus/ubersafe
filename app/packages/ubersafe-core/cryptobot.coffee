# CryptoBot client API

# create the worker
worker = new Worker "/cryptobot/cryptobot.js"

# command execution and result handling
deferred = null
worker.addEventListener "message", (e) ->
  data = e.data
  switch data.type
    when "result"
      if deferred
        deferred.resolve data.result
        deferred = null
      else
        console.error "[cryptobot]: worker returned result without deferred"
    when "error"
      console.error "[cryptobot]: worker error", data.error
      if deferred
        deferred.reject data.error
        deferred = null
    when "log" then console.log "[cryptobot]: #{data.message}"
    else console.error "[cryptobot]: unrecognized message from worker", data

executeCommand = (cmd, args) ->
  if deferred
    console.warn "[cryptobot]: executing new command before the previous one returned a result"
    deferred.reject "interrupted by new command"

  deferred = $.Deferred()
  message =
    command: cmd

  if args then message = _.extend args, message

  worker.postMessage message

  deferred.promise()

# entropy
addEntropy = (args) ->
  # send entropy to worker
  worker.postMessage
    command: "addEntropy"
    args: args

# add some entropy from window.crypt if available
addEntropyFromWindowCrypto = ->
  if not Uint32Array then return

  ab = new Uint32Array 32
  if window.crypto and window.crypto.getRandomValues
    window.crypto.getRandomValues ab
  else if window.msCrypto and window.msCrypto.getRandomValues
    window.msCrypto.getRandomValues ab
  else
    return

  addEntropy [ab, 1024, "crypto.getRandomValues"]

addEntropyFromWindowCrypto()

# hack into local sjcl's entropy collection and propagate it to the web worker
localAddEntropy = sjcl.random.addEntropy
sjcl.random.addEntropy = ->
  # call the local addEntropy
  localAddEntropy.apply sjcl.random, arguments

  # need to clone the arguments because it's not a real array
  len = arguments.length
  clonedArguments = (arguments[index] for index in [0...len])

  addEntropy clonedArguments

# API
CryptoBot =
  encryptString: (plaintext, encryptionData) ->
    executeCommand "encryptString",
      plaintext: plaintext
      key: encryptionData.key
      iv: encryptionData.iv

  decryptString: (ciphertext, encryptionData) ->
    executeCommand "decryptString",
      ciphertext: ciphertext
      key: encryptionData.key
      iv: encryptionData.iv