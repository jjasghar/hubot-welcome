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
    welcome = robot.brain.get('data.welcome') # pull out the welcome message
    stored_users = robot.brain.get('data.users') # get a list of the known stored users
    users = robot.brain.usersForFuzzyName("#{msg.message.user.name}") # get the user name of someone saying something
    if users in stored_users # if the user above is in the stored_users do nothing
    else
      msg.send "Welcome, #{msg.message.user.name}, #{welcome}" # if it's the first time you're seeing them give them the welcome message
      robot.brain.set 'data.users', msg.message.user.name # add the user name to the stored_users


  robot.respond /welcome (.*)$/i, (msg) ->
    welcome = msg.match[1]
    robot.brain.set 'data.welcome', welcome.trim()
    msg.send "Updated the welcome to: #{welcome}"
