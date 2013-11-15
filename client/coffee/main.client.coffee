# This is the last invocation after everything else is loaded
Meteor.startup ->
  # initEmblem "emblem-canvas", "bf4shapes/", false
  logger.info "Client startup done"