Template.browser.emblems =->
  Emblems.find {}, {fields: {name: 1, isPremium: 1, isUnlockable: 1, layers: 1}, sort: {createdOn: -1}, limit: 10}

Template.browser.events
  "click .show-emblem": ->
    return if Session.get "active_emblem" is @._id
    Session.set "active_emblem", @._id
    
    $(event.target).closest('table').find('tr').removeClass('active')
    $(event.target).closest('tr').addClass('active')
    
    text = loadEmblemWithId @._id
    
    if text?
      $('#emblem-preview-area').show()
      $emblemCode = $('#emblem-code')
      $emblemCode.val "emblem.emblem.load(" + text + ");"
  
  "click .delete-emblem": ->
    Emblems.remove {_id: @._id}