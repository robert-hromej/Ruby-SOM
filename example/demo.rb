require "bundler/setup"
require 'benchmark'

Dir["./lib/**/*.rb"].each { |file| require file }

folders = ['output', 'dump']
folders.each { |folder| Dir.mkdir folder unless Dir.exist? folder }

#file_name = 'three_color'
file_name = 'eight_color'
#file_name = 'iris'
#file_name = 'cows'

dataset_file_path = "example/datasets/#{file_name}.csv"
some_file_path = "dump/#{file_name}.som"

if File.exist? some_file_path
  som = SomManager.open some_file_path
else
  grid = {:type => :hexagonal, :rows => 50, :cols => 50, :ceil_size => 15}
  attributes = {:grid => grid, :dataset => dataset_file_path,
                :neighborhood_radius => 30,
                :learning_rate => 0.3,
                :epochs => 100}

  som = SOM.new attributes
  som.run_train
  #SomManager.save(som, some_file_path)
end

output_dir = "output/#{file_name}"
Dir.mkdir output_dir unless Dir.exist? output_dir

som.draw output_dir
