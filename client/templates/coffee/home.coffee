Template.home.rendered =->
  # change this implementation to use something like $.on(...)
  # warning: this renders all the time when the collection changes
  initEmblem "emblem-canvas", "bf4shapes/", false
  
  # code from: http://stackoverflow.com/a/5797700/660428
  emblemCode = $('#emblem-code')[0]
  emblemCode.onfocus =->
    emblemCode.select()
    
    # Work around Chrome's little problem
    emblemCode.onmouseup =->
          # Prevent further mouseup intervention
          emblemCode.onmouseup = null
          false

#Template.browser.events
  #"click #emblem-code": ->
    #$(event.target).select()

Template.browser.emblems =->
  Emblems.find {}, {fields: {'name': 1}}

Template.browser.events
  "click .show": ->
    return if Session.get "active_emblem" is @._id
    Session.set "active_emblem", @._id
    
    $(event.target).closest('table').find('tr').removeClass('active')
    $(event.target).closest('tr').addClass('active')
    
    text = loadEmblemWithId @._id
    
    if text?
      $emblemCode = $('#emblem-code')
      $emblemCode.val "emblem.emblem.load(" + text + ");"
      