showUploadError = (msg) ->
  $errorBox = $('#error-box')
  $errorMessage = $('#error-message')
  
  $errorMessage.val msg
  $errorBox.show()

showEmblemFound = (_id) ->
  $foundBox = $('#found-box')
  $foundLink = $('#found-link')
  
  $foundLink.attr 'href', Router.path('emblem', {_id: _id})
  $foundBox.show()

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
    event.preventDefault()
    
    $data = $('.upload #upload-text')
    $foundAt = $('.upload #foundAt')
    $creator = $('.upload #creator')
    $name = $('.upload #name')
    
    emblemData = $data.val().trim()
    emblemName = $name.val().trim()
    creator = $creator.val().trim()
    foundAt = $foundAt.val().trim()
    
    #return if Emblems.findOne({name:emblemName})?
    #return if emblemData.length == 0
    
    # removing the invocation-code
    emblemData = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(emblemData)[1] if emblemData.indexOf("emblem.emblem") >= 0
    emblemDataObject = JSON.parse(emblemData)
    
    layers = emblemDataObject.objects.length

    return showUploadError "no layers were found" if layers is 0
    return showUploadError "more than 40 layers found" if layers > 40
    
    premiumKeys = _.chain(bf4data.badgeParts).where({isPremium: true}).pluck("title").value()
    unlockKeys = _.chain(bf4data.badgeParts).where({isUnlock: true}).pluck("title").value()
    currentKeys = _.chain(emblemDataObject.objects).pluck("asset").uniq().value()
    
    isPremium = _.some currentKeys, (key) ->
      _.contains premiumKeys, key

    isUnlockable = _.some currentKeys, (key) ->
      _.contains unlockKeys, key
    
    _.each emblemDataObject.objects, (item) ->
      item.selectable = false
    
    emblemData = JSON.stringify(emblemDataObject)
    
    emblemHash = emblemData.toLowerCase().hashCode()
    
    similarEmblem = Emblems.findOne {hash:emblemHash}, {fields:{_id: 1}}
    
    return showEmblemFound similarEmblem._id if similarEmblem?
    
    id = Emblems.insert
      data: emblemData
      name: emblemName
      isPremium: isPremium
      isUnlockable: isUnlockable
      creator: creator
      foundAt: foundAt
      layers: layers
    
    Router.go('emblem', {_id: id})