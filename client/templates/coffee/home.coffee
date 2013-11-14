Template.home.events
  "click #emblem-draw-it": ->
    loadEmblem $('#emblem-data').val()
  "click #example-1": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=aACPH8Wk" # will execute the script anyway - BAD!!
  "click #example-2": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=5CzFsi8E" # will execute the script anyway - BAD!!
  "click #example-3": ->
    clearEmblem()
    $.getScript "http://pastebin.com/raw.php?i=yWXQSHc6" # will execute the script anyway - BAD!!

Template.home.rendered =->
  initEmblem("emblem-canvas", "bf4shapes/", false)