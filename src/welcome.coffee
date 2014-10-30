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

appendAmbush = (data, toUser, fromUser, message) ->
  data[toUser.name] or= []

  data[toUser.name].push [fromUser.name, message]

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.ambushes ||= {}

  robot.respond /welcome (.*?): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    user = users[0]
    appendAmbush(robot.brain.data.ambushes, user, msg.message.user, msg.match[2])
    msg.send "Ambush prepared"


  robot.hear /./i, (msg) ->
    return unless robot.brain.data.ambushes?
    if (ambushes = robot.brain.data.ambushes[msg.message.user.name])
      for ambush in ambushes
        msg.send msg.message.user.name + ": while you were out, " + ambush[0] + " said: " + ambush[1]
      delete robot.brain.data.ambushes[msg.message.user.name]
