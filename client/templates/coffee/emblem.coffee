Template.emblem.rendered =->
  # change this implementation to use something like $.on(...)
  # warning: this renders all the time when the collection changes
  initEmblem "emblem-canvas", "/bf4shapes/", false
  
  # code from: http://stackoverflow.com/a/5797700/660428
  emblemCode = $('#emblem-code')[0]
  emblemCode.onfocus =->
    emblemCode.select()
    
    # Work around Chrome's little problem
    emblemCode.onmouseup =->
          # Prevent further mouseup intervention
          emblemCode.onmouseup = null
          false
    
  text = loadEmblemWithId Router.current().params._id
  if text?
    $('#emblem-preview-area').show()
    $emblemCode = $('#emblem-code')
    $emblemCode.val "emblem.emblem.load(" + text + ");"

Template.emblem.emblem =->
  Emblems.findOne {_id:Router.current().params._id}, {fields: {name: 1, isPremium: 1, isUnlockable: 1, layers: 1}}

Template.emblem.events
  "click .delete-emblem": ->
    Emblems.remove {_id: Router.current().params._id}
    Router.go('home')