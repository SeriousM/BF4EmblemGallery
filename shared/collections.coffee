# Collection Definition goes Here
# eg:
#   @Posts = new Meteor.Collection "posts"

@Emblems = new Meteor.Collection "emblems"

checkDoc = (doc) ->
  check doc.data, String
  check doc.name, String
  check doc.banned, Boolean
  check doc.isPremium, Boolean
  check doc.isUnlockable, Boolean
  check doc.hash, Number
  check doc.foundAt, String
  check doc.userId, String
  check doc.layers, Number
  check doc.createdOn, Number

Emblems.allow
  insert: (userId, doc) ->
    return false unless doc? or user?
    checkDoc doc
    true
  
  remove: (userId, doc) ->
    return false unless doc? or user?
    checkDoc doc
    Meteor.call('isAdmin')

  update: (userId, doc) ->
    return false unless doc? or user?
    checkDoc doc
    Meteor.call('isAdmin')