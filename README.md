SHITTY-ROUTER
=============

I needed a really simple url router, that I could make more than one of. All of the options I looked at were a bit too complicated, or weren't reentrant, so I just went ahead and wrote a little one myself. It was pretty straightforward, but I figured it might help someone else.

Usage
-----

``` coffeescript
ShittyRouter = require 'shitty-router'

myrouter = new ShittyRouter

# .addRouteRegex takes a regular expression, the names of any parameters,
# and the callback to fire if the expression is matched
#
# The callback takes first any parameters specified in regular expression,
# and second, additional information provided by the matcher

myrouter.addRouteRegex /\/user\/(?:([^\/]+?))$/, ["userid"], (params, extras) ->
  extras.res.end("Matched to /user/" + params.userid)

# You can skip the parameters if there aren't any

myrouter.addRouteRegex /\/test/, (params, extras) ->
  extras.res.end("Matched to /test")

# .match returns true if it matches any routes, and false if it doesn't
# it also calls the route's callback. You can pass that callback an object with
# anything it needs to know about.
server = http.createServer (req, res) ->
  res.end "404'd!" if not myrouter.match req.url, { req: req, res: res }
server.listen 8080
```

Todo
----
I'll add the ability to specify routes in the form of "/user/:id" soon I hope.

License
-------

Copyright (C) 2012 Ian Cox

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
