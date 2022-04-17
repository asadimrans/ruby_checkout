#!/usr/bin/env ruby

require 'pry'
require 'json'

Dir['./lib/**/*.rb'].each { |file| require file }

CheckOut.new(ARGV[0], ARGV[1], ARGV[2]).process
