# Collection Definition goes Here
# eg:
#   @Posts = new Meteor.Collection "posts"

@Emblems = new Meteor.Collection "emblems"

Emblems.allow
  insert: (userId, doc) ->
    Meteor.call('isAdmin')
  
  remove: (userId, doc) ->
    Meteor.call('isAdmin')

  update: (userId, doc) ->
    Meteor.call('isAdmin')
