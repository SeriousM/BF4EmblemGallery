# Publications goes here
#eg:
#  Meteor.publish "posts", ->
#    Posts.find owner: @.userId

Meteor.publish "emblems", ->
  Emblems.find()

# Always publish logged-in user's roles so client-side checks can work.
Meteor.publish null, ->
  userId = @userId
  fields = admin: 1
  Meteor.users.find { _id: userId }, { fields: fields }