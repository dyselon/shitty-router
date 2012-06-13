assert = require 'assert'
ShittyRouter = require '../lib/shitty-router'

suite 'Regex Matching', () ->
  
  test 'Returns true on matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], () ->
    assert router.match '/test'
    
  test 'Returns false on non-matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex /\/test/, [], () ->
    assert not router.match '/fail'
    
  test 'Parameters get matched', (done) ->
    router = new ShittyRouter
    router.addRouteRegex /^\/test\/(?:([^\/]+?))$/, ["foo"], (params, extraparams) ->
      assert params.foo == '42'
      done()
    router.match '/test/42'

  test 'Multiple parameters get matched', (done) ->
    router = new ShittyRouter
    router.addRouteRegex /^\/test\/(?:([^\/]+?))\/thing\/(?:([^\/]+?))$/, ["foo", "bar"], (params, extraparams) ->
      assert params.foo == '42'
      assert params.bar == 'whatever'
      done()
    router.match '/test/42/thing/whatever'

suite 'String Matching', () ->

  test 'Returns true on matching string route', () ->
    router = new ShittyRouter
    router.addRoute "/test", () ->
    assert router.match '/test'
    
  test 'Returns false on non-matching string route', () ->
    router = new ShittyRouter
    router.addRoute "/test", () ->
    assert not router.match '/fail'
    
  test 'Parameters get matched on strings', (done) ->
    router = new ShittyRouter
    router.addRoute "/test/:foo", (params, extraparams) ->
      assert params.foo == '42'
      done()
    router.match '/test/42'
    
  test 'Multiple parameters get matched on strings', (done) ->
    router = new ShittyRouter
    router.addRoute "/test/:foo/thing/:bar", (params, extraparams) ->
      assert params.foo == 'stuff'
      assert params.bar == '123'
      done()
    #console.log '\n------------'
    #console.log router
    #console.log router.routes[0].params
    router.match '/test/stuff/thing/123'
    
suite 'Multiple routes', () ->

  # TODO: test multiple routes
  test 'Multiple routes with no overlap - first gets called', (done) ->
    router1 = new ShittyRouter
    router1.addRoute '/foo', () ->
      assert true
      done()
    router1.addRoute '/bar', () ->
      assert false
      done()
    router1.match '/foo'

  test 'Multiple routes with no overlap - second gets called', (done) ->
    router2 = new ShittyRouter
    router2.addRoute '/foo', () ->
      assert false
      done()
    router2.addRoute '/bar', () ->
      assert true
      done()
    router2.match '/bar'
    
  test 'Identical routes - first gets called', (done) ->
    router = new ShittyRouter
    router.addRoute '/foo', () ->
      assert true
      done()
    router.addRoute '/foo', () ->
      assert false
      done()
    router.match '/foo'

suite 'Callbacks', () ->
  
  test 'Callbacks get called', (done) ->
    router = new ShittyRouter
    router.addRoute '/test', () ->
      done()
    router.match '/test'
    
  test 'Callbacks get passed extra params', (done) ->
    router = new ShittyRouter
    router.addRoute '/test', (params, extraparams) ->
      assert extraparams == 'extra'
      done()
    router.match '/test', 'extra'
    
# TODO METHODS ALREADY
