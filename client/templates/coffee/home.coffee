Template.home.rendered =->
  # change this implementation to use something like $.on(...)
  initEmblem "emblem-canvas", "bf4shapes/", false

Template.browser.emblems =->
  Emblems.find {}, {fields: {'name': 1}}

Template.browser.events
  "click .show": ->
    return if Session.get "active_emblem" is @._id
    Session.set "active_emblem", @._id
    
    $(event.target).closest('table').find('tr').removeClass('active')
    $(event.target).closest('tr').addClass('active')
    
    loadEmblemWithId @._id