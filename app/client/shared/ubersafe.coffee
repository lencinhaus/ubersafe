# constants
COOKIE_LAST_USERNAME = 'ubersafe-last-username'
ECC_CURVE = sjcl.ecc.curves["c256"]

@UberSafe =
  getLastUsername: ->
    Cookie.get COOKIE_LAST_USERNAME

  setLastUsername: (username) ->
    if username
      Cookie.set COOKIE_LAST_USERNAME, username,
        path: '/'
    else
      Cookie.remove COOKIE_LAST_USERNAME

  generateUserKeys: ->
    keys = sjcl.ecc.elGamal.generateKeys ECC_CURVE
    userKeys =
      public: JSON.stringify keys.pub._point.toBits()
      private: JSON.stringify keys.sec._exponent.toBits()
    userKeys

  encryptSymmetric: (password, plaintext) ->
    sjcl.encrypt password, plaintext