# Description:
#   Sends a welcome message to the first thing someone new says something
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot welcome <new welcome message>
#
# Author:
#   jjasghar
#   awaxa

appendWelcome = (data, toUser, fromUser, message) ->
  data[toUser.name] or= []

  data[toUser.name].push [fromUser.name, message]

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.welcomes ||= {}

  #robot.enter (res) ->  ### This could be extremely useful, to add this to the list of the users it knows about
  #  res.reply 'welcome!'### Then after that if it doesnt match against it; it gives the welcome message?

  robot.respond /welcome (.*?)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    user = users[0]
    appendWelcome(robot.brain.data.welcome, user, msg.message.user)
    msg.send "user added"

  robot.hear /./i, (msg) ->
    if (welcomes = robot.brain.data.welcome[msg.message.user.name])
      for welcome in welcomes
        msg.send msg.message.user.name
