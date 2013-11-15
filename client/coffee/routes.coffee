# The iron router config

Router.configure layoutTemplate: 'layout'

Router.map ->
  @route 'home', path: '/'
  @route 'upload', path: '/upload'
  @route 'test', path: '/test'
  @route 'notFound', path: '*'
  # @route 'post', path: '/post/:_id'