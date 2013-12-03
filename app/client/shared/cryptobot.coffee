# create the worker
worker = new Worker "cryptobot/cryptobot.js"

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
# hack into local sjcl's entropy collection and propagate it to the web worker
localAddEntropy = sjcl.random.addEntropy
sjcl.random.addEntropy = ->
  # call the local addEntropy
  localAddEntropy.apply sjcl.random, arguments

  # need to clone the arguments because it's not a real array
  len = arguments.length
  clonedArguments = (arguments[index] for index in [0...len])

  # send entropy to worker
  worker.postMessage
    command: "addEntropy"
    args: clonedArguments

# API
@CryptoBot =
  encryptString: (str) ->
    executeCommand "encryptString",
      string: str