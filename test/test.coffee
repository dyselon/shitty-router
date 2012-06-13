assert = require 'assert'
ShittyRouter = require '../lib/shitty-router'

suite 'ShittyRouter', () ->
  
  test 'Returns true on matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], () ->
    assert router.match '/test'
    
  test 'Returns false on non-matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], () ->
    assert not router.match '/fail'
    
    
  test 'Callbacks get called', (done) ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], () ->
      done()
    router.match '/test'
    
  test 'Callbacks get passed extra params', (done) ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], (params, extraparams) ->
      assert extraparams == 'extra'
      done()
    router.match '/test', 'extra'
    
  test 'Parameters get matched', (done) ->
    router = new ShittyRouter
    router.addRouteRegex /^\/test\/(?:([^\/]+?))$/, ["foo"], (params, extraparams) ->
      assert params.foo == '42'
      done()
    router.match '/test/42'

  