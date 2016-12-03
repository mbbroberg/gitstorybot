#!/usr/bin/env ruby

require 'rubygems'
require 'chatterbot/dsl'
require 'pry'
require "octokit"
require 'highline/import'
require 'pp'

login = ask('login: ')
password = ask('password: ') {|q| q.echo = '*'}

Octokit.auto_paginate = true ## Need this to get over 30 responses
client = Octokit::Client.new :login => login, :password => password

begin
  client.user
rescue Octokit::OneTimePasswordRequired
  otp = ask('OTP: ') {|q| q.echo = '*'}
  client.user login, :headers => {'X-GitHub-OTP' => otp}
end

#
# this is the script for the twitter bot gitstorybot
# generated on 2016-12-03 09:07:42 -0500
#

# Enabling **debug_mode** prevents the bot from actually sending
# tweets. Keep this active while you are developing your bot. Once you
# are ready to send out tweets, you can remove this line.
# debug_mode

# Chatterbot will keep track of the most recent tweets your bot has
# handled so you don't need to worry about that yourself. While
# testing, you can use the **no_update** directive to prevent
# chatterbot from updating those values. This directive can also be
# handy if you are doing something advanced where you want to track
# which tweet you saw last on your own.
no_update

# remove this to get less output when running your bot
verbose

# The blocklist is a list of users that your bot will never interact
# with. Chatterbot will discard any tweets involving these users.
# Simply add their twitter handle to this list.
# blocklist "abc", "def"

# If you want to be even more restrictive, you can specify a
# 'safelist' of accounts which your bot will *only* interact with. If
# you uncomment this line, Chatterbot will discard any incoming tweets
# from a user that is not on this list.
# safelist "foo", "bar"

# Here's a list of words to exclude from searches. Use this list to
# add words which your bot should ignore for whatever reason.
# exclude "hi", "spammer", "junk"

# Exclude a list of offensive, vulgar, 'bad' words. This list is
# populated from Darius Kazemi's wordfilter module
# @see https://github.com/dariusk/wordfilter
exclude bad_words

# This will restrict your bot to tweets that come from accounts that
# are following your bot. A tweet from an account that isn't following
# will be rejected
# only_interact_with_followers

#
# Specifying 'use_streaming' will cause Chatterbot to use Twitter's
# Streaming API. Your bot will run constantly, listening for tweets.
# Alternatively, you can run your bot as a cron/scheduled job. In that
# case, do not use this line. Every time you run your bot, it will
# execute once, and then exit.
#
# use_streaming

#
# Here's the fun stuff!
#

# Searches: You can do all sorts of stuff with searches on Twitter.
# However, please note, interacting with users who don't follow your
# bot is very possibly:
#  - rude
#  - uncool
#  - likely to get your bot suspended
#
# Still here? Hopefully it's because you're going to do something cool
# with the data that doesn't bother other people. Hooray!
#
# search "chatterbot" do |tweet|
#  # here's the content of a tweet
#  puts tweets.text
# end

#
# this block responds to mentions of your bot
#
replies do |tweet|
  # Any time you put the #USER# token in a tweet, Chatterbot will
  # replace it with the handle of the user you are interacting with
  reply 'Thanks for tweeting #USER#, but I only listen to DMs from my contributors.', tweet
end

#
# this block handles incoming Direct Messages. if you want to do
# something with DMs, go for it!
#
direct_messages do |dm|
 puts "DM received: #{dm.text}"
 this = dm.urls[0].display_url.split('/')

 if this[0] == 'github.com'
   puts 'Received a valid GitHub URL'
   puts 'Preparing to storytell'
   direct_message 'Preparing to storytell', dm.sender

   commits = client.commits(this[1] + '/' + this[2])
   if commits 
     commits.each do |c|
       binding.pry
     end
   end
 end
end

#
# Use this block to get tweets that appear on your bot's home timeline
# (ie, if you were visiting twitter.com) -- using this block might
# require a little extra work but can be very handy
#
# home_timeline do |tweet|
#  puts tweet.inspect
# end

#
# Use this block if you want to be notified about new followers of
# your bot. You might do this to follow the user back.
#
# NOTE: This block only works with the Streaming API. If you use it,
# chatterbot will assume you want to use streaming and will
# automatically activate it for you.
#
# followed do |user|
#  puts user.inspect
# end

#
# Use this block if you want to be notified when one of your tweets is
# favorited. The object passed in will be a Twitter::Streaming::Event
# @see http://www.rubydoc.info/gems/twitter/Twitter/Streaming/Event
#
# NOTE: This block only works with the Streaming API. If you use it,
# chatterbot will assume you want to use streaming and will
# automatically activate it for you.
#
# favorited do |event|
#  puts event.inspect
# end

#
# Use this block if you want to be notified of deleted tweets from
# your bots home timeline. The object passed in will be a
# Twitter::Streaming::DeletedTweet
# @see http://www.rubydoc.info/gems/twitter/Twitter/Streaming/DeletedTweet
#
# NOTE: This block only works with the Streaming API. If you use it,
# chatterbot will assume you want to use streaming and will
# automatically activate it for you.
#
#deleted do |tweet|
#
#end
  
