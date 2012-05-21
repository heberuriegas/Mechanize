#!/usr/bin/env ruby

# RoR Environment
ENV["RAILS_ENV"] ||= "development"
require File.dirname(__FILE__) + "/../config/environment"

n = 1 # How many users
delay = 30+Random.rand(30) # Seconds to delay

survey = VentureLab.new('heber.fernando@gmail.com','hihihi')
#survey.send_message(VentureLab.random_users(n),delay)
survey.view_profile
