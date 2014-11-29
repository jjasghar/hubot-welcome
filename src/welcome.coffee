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
#   hubot welcome <new welcome message> - Update the welcome message
#
# Author:
#   jjasghar

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.welcome ||= {}
    robot.brain.data.users ||= [ ]

  robot.enter (msg) ->
    welcome = robot.brain.get('data.welcome')
    stored_users = robot.brain.get('data.users')
    users = robot.brain.usersForFuzzyName("#{msg.message.user.name}")
    if ~stored_users.indexOf users
    else
      msg.send "Welcome, #{msg.message.user.name}, #{welcome}"
      robot.brain.set 'data.users', msg.message.user.name


  robot.respond /welcome (.*)$/i, (msg) ->
    welcome = msg.match[1]
    robot.brain.set 'data.welcome', welcome.trim()
    msg.send "Updated the welcome to: #{welcome}"
