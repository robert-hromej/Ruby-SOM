#require "bundler"
#Bundler.require

require './base/math'
require './base/array'

require './lib/som'
require './lib/neuron'
require './lib/grid/hexagonal'
require './lib/grid/square'
require './lib/grid/grid_type'
require './lib/grid'
require './lib/drawer'

#require './datasets/three_color'
require './datasets/eight_color'
#require './datasets/iris'
#require './datasets/cows'

folders = ['output', 'dump']
folders.each { |folder| Dir.mkdir folder unless Dir.exist? folder }

attributes = {dimension: DIMENSION,
              grid: {type: :hexagonal, rows: 40, cols: 40, ceil_size: 15},
              #grid: {type: :square, rows: 30, cols: 30, ceil_size: 7},
              data: DATA_SET,
              neighborhood_radius: 15,
              learning_rate: 0.8,
              epochs: 250}

som_file = SOM.file_name(attributes)
som_file = "dump/#{som_file}.som"

if File.exist? som_file
  som = SOM.load som_file
  som.grid.ceil_size = attributes[:grid][:ceil_size]
else
  som = SOM.new attributes
  som.run_train
  som.save
end

require 'benchmark'

p "Start generate images...please wait"
puts Benchmark.realtime {
  som.history.map do |iteration, neurons|
    puts "iteration: #{iteration}"
    step = 10
    if iteration == som.epochs-1 or iteration%step == 0
      som.neurons = Marshal.load(neurons)
      som.current_iteration = iteration
      #Drawer.new(som: som, type: :rasem).draw
      #Drawer.new(som: som, type: :chunky).draw
      Drawer.new(som: som, type: :rmagick).draw
    end
  end
}

#Drawer.create_animation(som.file_name, file_names.compact)

#require 'scruffy'
#
#graph = Scruffy::Graph.new
#graph.title = "Sample Line Graph"
#graph.renderer = Scruffy::Renderers::Standard.new
#
#graph.add :line, 'Example', [20, 100, 70, 30, 106]
#
#graph.render :to => "line_test.svg"

#ceil_size = 5
#drawer = Drawer.new(width: som.grid.cols*ceil_size, height: som.grid.rows*ceil_size, som: som)
#drawer.save 'output/img.gif'

