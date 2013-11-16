# The iron router config

Router.configure layoutTemplate: 'layout'

Router.map ->
  @route 'home', path: '/'
  @route 'emblem', path: '/e/:_id'
  @route 'upload', path: '/add'
  @route 'faq', path: '/faq'
  @route 'test', path: '/test'
  @route 'notFound', path: '*'
  # @route 'post', path: '/post/:_id'