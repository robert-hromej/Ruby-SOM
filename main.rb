require "bundler/setup"
require 'benchmark'
require 'yaml'

require './ext/math'

Dir["./lib/**/*.rb"].each { |file| require file }

folders = ['output', 'dump']
folders.each { |folder| Dir.mkdir folder unless Dir.exist? folder }

config = YAML::load(File.open('config.yml'))

some_file_path = "dump/#{config[:name]}.som"

if File.exist? some_file_path
  som = SomManager.open some_file_path
else
  som = SOM.new config
  som.run_train
  SomManager.save(som, some_file_path)
end

output_dir = "output/#{config[:name]}"
Dir.mkdir output_dir unless Dir.exist? output_dir

som.draw output_dir
