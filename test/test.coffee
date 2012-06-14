assert = require 'assert'
ShittyRouter = require '../lib/shitty-router'

suite 'Regex Matching', () ->
  
  test 'Returns true on matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex "GET", /\/test/, [], () ->
    assert router.match "GET", '/test'
    
  test 'Returns false on non-matching route', () ->
    router = new ShittyRouter
    router.addRouteRegex "GET", /\/test/, [], () ->
    assert not router.match "GET", '/fail'
    
  test 'Parameters get matched', (done) ->
    router = new ShittyRouter
    router.addRouteRegex "GET", /^\/test\/(?:([^\/]+?))$/, ["foo"], (params, extraparams) ->
      assert params.foo == '42'
      done()
    router.match "GET", '/test/42'

  test 'Multiple parameters get matched', (done) ->
    router = new ShittyRouter
    router.addRouteRegex "GET", /^\/test\/(?:([^\/]+?))\/thing\/(?:([^\/]+?))$/, ["foo", "bar"], (params, extraparams) ->
      assert params.foo == '42'
      assert params.bar == 'whatever'
      done()
    router.match "GET", '/test/42/thing/whatever'

suite 'String Matching', () ->

  test 'Returns true on matching string route', () ->
    router = new ShittyRouter
    router.addRoute "GET", "/test", () ->
    assert router.match "GET", '/test'
    
  test 'Returns false on non-matching string route', () ->
    router = new ShittyRouter
    router.addRoute "GET", "/test", () ->
    assert not router.match "GET", '/fail'
    
  test 'Parameters get matched on strings', (done) ->
    router = new ShittyRouter
    router.addRoute "GET", "/test/:foo", (params, extraparams) ->
      assert params.foo == '42'
      done()
    router.match "GET", '/test/42'
    
  test 'Multiple parameters get matched on strings', (done) ->
    router = new ShittyRouter
    router.addRoute "GET", "/test/:foo/thing/:bar", (params, extraparams) ->
      assert params.foo == 'stuff'
      assert params.bar == '123'
      done()
    router.match "GET", '/test/stuff/thing/123'
    
suite 'Multiple routes', () ->

  # TODO: test multiple routes
  test 'Multiple routes with no overlap - first gets called', (done) ->
    router1 = new ShittyRouter
    router1.addRoute "GET", '/foo', () ->
      assert true
      done()
    router1.addRoute "GET", '/bar', () ->
      assert false
      done()
    router1.match "GET", '/foo'

  test 'Multiple routes with no overlap - second gets called', (done) ->
    router2 = new ShittyRouter
    router2.addRoute "GET", '/foo', () ->
      assert false
      done()
    router2.addRoute "GET", '/bar', () ->
      assert true
      done()
    router2.match "GET", '/bar'
    
  test 'Identical routes - first gets called', (done) ->
    router = new ShittyRouter
    router.addRoute "GET", '/foo', () ->
      assert true
      done()
    router.addRoute "GET", '/foo', () ->
      assert false
      done()
    router.match "GET", '/foo'

suite 'Callbacks', () ->
  
  test 'Callbacks get called', (done) ->
    router = new ShittyRouter
    router.addRoute "GET", '/test', () ->
      done()
    router.match "GET", '/test'
    
  test 'Callbacks get passed extra params', (done) ->
    router = new ShittyRouter
    router.addRoute "GET", '/test', (params, extraparams) ->
      assert extraparams == 'extra'
      done()
    router.match "GET", '/test', 'extra'
    
suite 'Methods', () ->
  
  test 'Only matched method fires', (done) ->
    router = new ShittyRouter
    router.addRoute "POST", '/foo', () ->
      assert false
      done()
    router.addRoute "GET", '/foo', () ->
      assert true
      done()
    router.match "GET", '/foo'
    
  test 'Methods work with arrays', (done) ->
    router = new ShittyRouter
    router.addRoute ["GET", "POST"], '/foo', () ->
      assert true
      done()
    router.match "GET", '/foo'
    
  test 'ANY method matches anything', (done) ->
    router = new ShittyRouter
    router.addRoute "ANY", '/foo', () ->
      assert true
      done()
    router.match "GET", '/foo'
