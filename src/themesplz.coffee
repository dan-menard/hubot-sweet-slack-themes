# FIXME: Add comments!

module.exports = (robot) ->
  SWEET_THEMES_URL = "http://sweetthemesaremadeofthe.se/api/read/json"

  dataFromJsonp = (jsonpBody) ->
    jsonpBodyAsString = jsonpBody.toString()
    bodyAsString = jsonpBodyAsString.substring(jsonpBodyAsString.indexOf('{'), jsonpBodyAsString.length-2)

    JSON.parse(bodyAsString)

  themeFromPost = (post) ->
    title = post['regular-title']

    postContent = post['regular-body']
    theme = postContent.substring(postContent.indexOf("<blockquote>") + 12, postContent.indexOf("</blockquote>"))

    "#{title}: #{theme}"

  robot.respond /themesplz/i, (msg) ->
    robot
      .http(SWEET_THEMES_URL)
      .post() (err, res, body) ->
        content = dataFromJsonp(body)

        themes = []
        themes.push themeFromPost(post) for post in content.posts[0..4]

        msg.send themes.join("<br/>")
