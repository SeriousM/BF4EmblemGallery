# The iron router config

Router.configure layoutTemplate: 'layout'

Router.map ->
  @route 'home', path: '/'
  @route 'notFound', path: '*'
  # @route 'post', path: '/post/:_id'