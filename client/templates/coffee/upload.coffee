Template.upload.events
  "submit #upload-form": ->
    event.preventDefault()
    
    $data = $('.upload #upload-text')
    $foundAt = $('.upload #foundAt')
    $creator = $('.upload #creator')
    $name = $('.upload #name')
    $premium = $('.upload #premium:checked') # can be undefined because of the :checked filter
    
    emblemData = $data.val().trim()
    emblemName = $name.val().trim()
    creator = $creator.val().trim()
    foundAt = $foundAt.val().trim()
    userId = 0
    premium = $premium?
    created_on = new Date().getTime()
    
    return if emblemData.length == 0
    
    emblemData = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(emblemData)[1]  if emblemData.indexOf("emblem.emblem") >= 0
    emblemDataObject = JSON.parse(emblemData)
    
    layers = emblemDataObject.objects.length
    
    return if layers is 0
    
    emblemData = JSON.stringify(emblemDataObject)
    
    emblemHash = emblemData.toLowerCase().hashCode()
    
    return if Emblems.findOne({hash:emblemHash})?
    
    Emblems.insert
      data: emblemData
      name: emblemName
      banned: false
      premium: premium
      hash: emblemHash # data.tolower.hash
      creator: creator
      foundAt: foundAt
      userId: userId
      layers: layers
      created_on: created_on
    
    # reset the fields
    $data = $data.val('')
    $foundAt = $foundAt.val('')
    $creator = $creator.val('')
    $name = $name.val('')