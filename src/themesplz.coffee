# FIXME: Add comments!

module.exports = (robot) ->
  SWEET_THEMES_URL = "http://sweetthemesaremadeofthe.se/api/read/json"

  dataFromJsonp = (jsonpBody) ->
    jsonpBodyAsString = jsonpBody.toString()
    bodyAsString = jsonpBodyAsString.substring(jsonpBodyAsString.indexOf('{'), jsonpBodyAsString.length-2)

    JSON.parse(bodyAsString)

  themeFromPost = (post) ->
    body = post['regular-body']

    title = post['regular-title']
    colours = coloursFromBody(body)
    thumbnail = thumbnailFromBody(body)

    "#{title}:\n#{colours}\n\n#{thumbnail}"

  coloursFromBody = (body) ->
    body.substring(body.indexOf('<blockquote>') + 12, body.indexOf('</blockquote>'))

  thumbnailFromBody = (body) ->
    body.substring(body.indexOf('https'), body.indexOf('.png') + 4)

  getWarning = (count) ->
    if count > 20
      "You asked for #{count} themes but I'm only giving you 20 because #{count} is like, a lot of themes."

  getError = (count) ->
    if isNaN(count)
      "Usage: `themesplz` || `themesplz {a number between 1 and 20}`"
    else if count == '0'
      "Here, 0 themes:"
    else if count < 0
      "Negative themes? Maybe this is what you want:" +
      "#ffffff #ffffff #ffffff #ffffff #ffffff #ffffff #ffffff #ffffff"

  robot.respond /themesplz(\s+(\S+))?/i, (msg) ->
    count =  msg.match[2] || 3
    reply = ""

    if warning = getWarning(count)
      reply += warning
    else if error = getError(count)
      msg.send error

    unless error
      robot
        .http(SWEET_THEMES_URL)
        .post() (err, res, body) ->
          content = dataFromJsonp(body)

          themes = []
          themes.push themeFromPost(post) for post in content.posts[0..count-1]

          msg.send "#{reply}\n\n#{themes.join('\n')}"
