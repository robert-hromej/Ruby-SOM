require 'simplecov'
SimpleCov.start

Dir["./lib/**/*.rb"].each { |file| require file }

require './ext/math'
