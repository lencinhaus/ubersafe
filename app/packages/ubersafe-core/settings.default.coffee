# set default settings
Meteor.settings = _.deepExtend
  public:
    name: "UberSafe"
    password:
      minLength: 6
, Meteor.settings or {}