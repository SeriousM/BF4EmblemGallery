Meteor.methods isAdmin: () ->
  return Meteor.user()?.admin