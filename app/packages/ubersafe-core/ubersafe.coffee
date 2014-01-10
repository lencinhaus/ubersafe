# constants
LOCAL_STORAGE_LAST_USERNAME_KEY = 'UberSafe.lastUsername'
ECC_CURVE = sjcl.ecc.curves["c384"]
SERIALIZATION_CODEC = sjcl.codec.hex

# deps
keysDependency = new Deps.Dependency()

# set default paranoia
sjcl.random.setDefaultParanoia(Meteor.settings.public.paranoia)

# start the entropy collectors
sjcl.random.startCollectors()

# initialization
Meteor.startup ->
  # ensure the user is logged out
  Meteor.logout ->
    setupKeyManagement()

# utility functions to ensure state consistency
ensurePassword = ->
  unless UberSafe._password then throw "password not set"
  return

ensureKeys = ->
  unless UberSafe._keys then throw "keys not set"
  return

setupKeyManagement = ->
  Deps.autorun ->
    # subscribe to ubersafe user properties
    Meteor.subscribe "userUberSafeData"

  Deps.autorun ->
    user = Meteor.user()
    if user
      # grab keys when a user signs in
      publicPointBits = SERIALIZATION_CODEC.toBits(user.ubersafe.keys.public)
      secretExponentBits = SERIALIZATION_CODEC.toBits(UberSafe.decryptSymmetric(sjcl.codec.utf8String.fromBits(SERIALIZATION_CODEC.toBits(user.ubersafe.keys.privateEncrypted))))
      secretExponentBn = sjcl.bn.fromBits(secretExponentBits)

      UberSafe._keys =
        publicSerialized: user.ubersafe.keys.public
        encryption:
          pub: new sjcl.ecc.elGamal.publicKey ECC_CURVE, publicPointBits
          sec: new sjcl.ecc.elGamal.secretKey ECC_CURVE, secretExponentBn
        signing:
          pub: new sjcl.ecc.ecdsa.publicKey ECC_CURVE, publicPointBits
          sec: new sjcl.ecc.ecdsa.secretKey ECC_CURVE, secretExponentBn
    else
      # forget keys and password when she signs out
      UberSafe._password = UberSafe._keys = null

    keysDependency.changed()
    return

# API
UberSafe =
  _password: null
  _keys: null

  setPassword: (password) ->
    @_password = password
    return

  clearPassword: ->
    @_password = null
    return

  getLastUsername: ->
    Meteor._localStorage.getItem LOCAL_STORAGE_LAST_USERNAME_KEY

  setLastUsername: (username) ->
    if username
      Meteor._localStorage.setItem LOCAL_STORAGE_LAST_USERNAME_KEY, username
    else
      Meteor._localStorage.removeItem LOCAL_STORAGE_LAST_USERNAME_KEY

    return

  generateUserKeys: ->
    keys = sjcl.ecc.elGamal.generateKeys ECC_CURVE
    publicPoint = keys.pub.get()
    secretExponentBits = keys.sec.get()

    public: SERIALIZATION_CODEC.fromBits(publicPoint.x) + SERIALIZATION_CODEC.fromBits(publicPoint.y)
    privateEncrypted: SERIALIZATION_CODEC.fromBits(sjcl.codec.utf8String.toBits(@encryptSymmetric(SERIALIZATION_CODEC.fromBits(secretExponentBits))))

  hasKeys: ->
    keysDependency.depend()
    return !!@_keys

  getPublicKey: ->
    ensureKeys()
    @_keys.publicSerialized

  encryptSymmetric: (plaintext) ->
    ensurePassword()
    sjcl.encrypt @_password, plaintext

  decryptSymmetric: (ciphertext) ->
    ensurePassword()
    sjcl.decrypt @_password, ciphertext

  encryptAsymmetric: (plaintext) ->
    ensureKeys()
    sjcl.encrypt @_keys.encryption.pub, plaintext

  decryptAsymmetric: (ciphertext) ->
    ensureKeys()
    sjcl.decrypt @_keys.encryption.sec, ciphertext

  sign: (data) ->
    hash = sjcl.hash.sha512.hash data
    signatureBits = @_keys.signing.sec.sign hash
    SERIALIZATION_CODEC.fromBits signatureBits

  verify: (data, signature) ->
    hash = sjcl.hash.sha512.hash data
    signatureBits = SERIALIZATION_CODEC.toBits signature

    try
      if @_keys.signing.pub.verify hash, signatureBits then true
    catch error
      unless error instanceof sjcl.exception.corrupt
        throw error

    false

  generateDocumentKey: ->
    key: sjcl.random.randomWords 8
    iv: sjcl.random.randomWords 4

  encryptDocumentKey: (key) ->
    @encryptAsymmetric EJSON.stringify key

  decryptDocumentKey: (encryptedKey) ->
    EJSON.parse @decryptAsymmetric encryptedKey
