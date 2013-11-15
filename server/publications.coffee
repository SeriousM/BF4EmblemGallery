# Publications goes here
#eg:
#  Meteor.publish "posts", ->
#    Posts.find owner: @.userId

Meteor.publish "emblems", ->
  Emblems.find()