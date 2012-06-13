exports = module.exports = class ShittyRouter
  constructor: () ->
    @routes = []

  addRouteRegex: (match, params, callback) ->
    if not callback?
      callback = params
      params = null
    @routes.push
      match: match
      params: params
      callback: callback
      
  match: (path, extraparams) ->
    for route in @routes
      results = route.match.exec(path)
      if results?
        params = {}
        for param, i in route.params
          params[param] = results[i+1]
        route.callback(params, extraparams)
        return true
    return false