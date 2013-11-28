Meteor.methods
  checkUserUniqueProperty: (property, value) ->
    check property, Match.Where (val) ->
      _.contains ["email", "username"], val
    selector = {}
    switch property
      when "username" then selector[property] = value
      when "email" then selector["emails"] =
        $elemMatch:
          address: value

    not Meteor.users.findOne(selector)?