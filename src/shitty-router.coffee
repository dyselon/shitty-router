exports = module.exports = class ShittyRouter
  constructor: () ->
    @routes = []

  addRouteRegex: (method, match, params, callback) ->
    if not callback?
      callback = params
      params = null
    @routes.push
      match: match
      params: params
      callback: callback
      method: method
      
  addRoute: (method, str, callback) ->
    # Swiped this regex from express. Thanks!
    params = []
    newstr = str.replace /(\/)?(\.)?:(\w+)(?:(\(.*?\)))?(\?)?/g, (_a, slash, _b, key, _c, _d) ->
      params.push key
      slash + "([^/.]+?)"
    @addRouteRegex method, new RegExp('^' + newstr + '$'), params, callback
      
  match: (method, path, extraparams) ->
    for route in @routes
      if route.method == "ANY" or (route.method instanceof Array and method in route.method) or method == route.method
        results = route.match.exec(path)
        if results?
          params = {}
          for param, i in route.params
            params[param] = results[i+1]
          if route.callback?
            route.callback(params, extraparams)
          return true
    return false