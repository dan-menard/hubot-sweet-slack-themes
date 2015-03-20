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

  robot.respond /themesplz( (\d+))?/i, (msg) ->
    count =  msg.match[2] || 3
    robot
      .http(SWEET_THEMES_URL)
      .post() (err, res, body) ->
        content = dataFromJsonp(body)

        themes = []
        themes.push themeFromPost(post) for post in content.posts[0..count-1]

        msg.send themes.join("\n")
