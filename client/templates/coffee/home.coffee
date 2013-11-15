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