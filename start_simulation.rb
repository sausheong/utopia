#!/usr/bin/env ruby

require 'bundler'
Bundler.require
require 'matrix'
require './base/log'

require "./#{ARGV[0]}/roid"
require "./#{ARGV[0]}/config"
require "./#{ARGV[0]}/utopia"

world = Utopia.new
world.show