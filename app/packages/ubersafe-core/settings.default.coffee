# set default settings
Meteor.settings = _.deepExtend
  public:
    name: "ÜberSafe"
    password:
      minLength: 6
    paranoia: 10 # a number between 1 and 10, 1 being the least secure, 10 the most secure
  simulatedLatency: 0 # number of ms server calls take
, Meteor.settings or {}