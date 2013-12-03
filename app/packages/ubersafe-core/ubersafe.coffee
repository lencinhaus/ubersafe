# constants
LOCAL_STORAGE_LAST_USERNAME_KEY = 'UberSafe.lastUsername'
ECC_CURVE = sjcl.ecc.curves["c256"]

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
      publicPointBits = JSON.parse user.ubersafe.keys.public
      secretExponentBits = JSON.parse UberSafe.decryptSymmetric user.ubersafe.keys.secretEncrypted
      UberSafe._keys =
        pub: new sjcl.ecc.elGamal.publicKey ECC_CURVE, publicPointBits
        sec: new sjcl.ecc.elGamal.secretKey ECC_CURVE, sjcl.bn.fromBits secretExponentBits
    else
      # forget keys and password when she signs out
      UberSafe._password = UberSafe._keys = null

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

  generateKeys: ->
    keys = sjcl.ecc.elGamal.generateKeys ECC_CURVE
    public: JSON.stringify keys.pub._point.toBits()
    secretEncrypted: @encryptSymmetric JSON.stringify keys.sec.get()

  encryptSymmetric: (plaintext) ->
    ensurePassword()
    sjcl.encrypt @_password, plaintext

  decryptSymmetric: (ciphertext) ->
    ensurePassword()
    sjcl.decrypt @_password, ciphertext

  encryptAsymmetric: (plaintext) ->
    ensureKeys()
    sjcl.encrypt @_keys.pub, plaintext

  decryptAsymmetric: (ciphertext) ->
    ensureKeys()
    sjcl.decrypt @_keys.sec, ciphertext