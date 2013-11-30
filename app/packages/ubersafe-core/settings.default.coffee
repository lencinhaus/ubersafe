# set default settings
Meteor.settings = _.deepExtend
  public:
    name: "ÜberSafe"
    password:
      minLength: 6
, Meteor.settings or {}