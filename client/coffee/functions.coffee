window.loadEmblem = (text) ->
  text = text.trim()
  text = /emblem.emblem.load\(([.\S\s]*)\);?/.exec(text)[1]  if text.indexOf("emblem.emblem") >= 0
  window.clearEmblem()
  emblem.emblem.load text
  window.disableEmblemInteractivity()

window.loadEmblemWithId = (id) ->
  text = Emblems.findOne({_id:id}, {fields: {'data': 1}})?.data
  return if !text?
  window.clearEmblem()
  emblem.emblem.load text
  window.disableEmblemInteractivity()

window.clearEmblem = ->
  emblem.emblem.clear()

window.disableEmblemInteractivity = ->
  _.each emblem.emblem.canvas._objects, (item) ->
    item.selectable = false