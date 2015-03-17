# FIXME: Add comments!

module.exports = (robot) ->
  robot.respond /themesplz/i, (msg) ->
    hardcodedthemesfornow = [
      "#373B39, #373B39, #373B39, #94D9B6, #C4D5CC, #68726D, #94D9B6, #94D9B6",
      "#25282B, #766bb7, #766bb7, #BFBEC3, #6F6E73, #BFBEC3, #A76B76, #A76B76"
    ]
    themes = hardcodedthemesfornow

    msg.send themes.join("\n")
