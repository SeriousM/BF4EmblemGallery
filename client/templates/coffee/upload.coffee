Template.upload.events
  "click #clear": ->
    $data = $('.upload #upload-text')
    $foundAt = $('.upload #foundAt')
    $creator = $('.upload #creator')
    $name = $('.upload #name')
    
    # reset the fields
    $data = $data.val('')
    $foundAt = $foundAt.val('')
    $creator = $creator.val('')
    $name = $name.val('')
    
  "submit #upload-form": ->
    # todo: add user friendly error messages (toast?) + if found, show link to existing one
    
    event.preventDefault()
    
    $data = $('.upload #upload-text')
    $foundAt = $('.upload #foundAt')
    $creator = $('.upload #creator')
    $name = $('.upload #name')
    
    emblemData = $data.val().trim()
    emblemName = $name.val().trim()
    creator = $creator.val().trim()
    foundAt = $foundAt.val().trim()
    userId = Meteor.user()._id
    created_on = new Date().getTime()
    
    return if Emblems.findOne({name:emblemName})?
    
    return if emblemData.length == 0
    
    emblemData = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(emblemData)[1]  if emblemData.indexOf("emblem.emblem") >= 0
    emblemDataObject = JSON.parse(emblemData)
    
    layers = emblemDataObject.objects.length
    
    return if layers is 0
    
    premiumKeys = _.chain(bf4data.badgeParts).where({isPremium: true}).pluck("title").value()
    unlockKeys = _.chain(bf4data.badgeParts).where({isUnlock: true}).pluck("title").value()
    currentKeys = _.chain(emblemDataObject.objects).pluck("asset").uniq().value()
    
    isPremium = _.all currentKeys, (v) ->
      _.include premiumKeys, v
    
    isUnlockable = _.all currentKeys, (v) ->
      _.include unlockKeys, v
    
    _.each emblemDataObject.objects, (item) ->
      item.selectable = false
    
    emblemData = JSON.stringify(emblemDataObject)
    
    emblemHash = emblemData.toLowerCase().hashCode()
    
    return if Emblems.findOne({hash:emblemHash})?
    
    Emblems.insert
      data: emblemData
      name: emblemName
      banned: false
      isPremium: isPremium
      isUnlockable: isUnlockable
      hash: emblemHash
      creator: creator
      foundAt: foundAt
      userId: userId
      layers: layers
      created_on: created_on