Template.home.events
  "click #emblem-draw-it": ->
    loadEmblem $('#emblem-data').val()
  "click #example-1": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=aACPH8Wk", disableEmblemInteractivity # will execute the script anyway - BAD!!
  "click #example-2": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=5CzFsi8E", disableEmblemInteractivity # will execute the script anyway - BAD!!
  "click #example-3": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=yWXQSHc6", disableEmblemInteractivity # will execute the script anyway - BAD!!
  "click #scale-50": ->
    $('#emblem-canvas').parent().addClass('scale50').removeClass('scale75').removeClass('scale100')
  "click #scale-75": ->
    $('#emblem-canvas').parent().removeClass('scale50').addClass('scale75').removeClass('scale100')
  "click #scale-100": ->
    $('#emblem-canvas').parent().removeClass('scale50').removeClass('scale75').addClass('scale100')

Template.home.rendered =->
  initEmblem("emblem-canvas", "bf4shapes/", false)