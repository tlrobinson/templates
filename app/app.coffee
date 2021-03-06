
express = require "express"
http = require "http"
path = require "path"

coffeeify = require "coffeeify"
browserify = require "browserify-middleware"
browserify.settings "transform", [coffeeify]

app = express()

app.configure ->
  app.set "port", process.env["PORT"] or 3000
  app.set "views", "#{__dirname}/views"
  app.set "view engine", "jade"

  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session()

  app.use app.router

  app.use require("stylus").middleware(__dirname + "/public")
  app.use express.static(path.join(__dirname, "public"))

  app.use "/javascripts/index.js", browserify("client/index.coffee")

app.configure "development", ->
  app.use express.errorHandler()

routes = require "./routes"
user = require "./routes/user"

app.get "/", routes.index
app.get "/users", user.list

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
