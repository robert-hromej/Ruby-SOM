require "bundler/setup"

Dir["./lib/**/*.rb"].each { |file| require file }

#dataset = 'example/datasets/three_color.csv'
#dataset = 'example/datasets/eight_color.csv'
dataset = 'example/datasets/iris.csv'
#dataset = 'example/datasets/cows.csv'

folders = ['output', 'dump']
folders.each { |folder| Dir.mkdir folder unless Dir.exist? folder }

#grid = {type: :square, rows: 30, cols: 30, ceil_size: 15}
grid = {type: :hexagonal, rows: 15, cols: 15, ceil_size: 15}
attributes = {grid: grid,
              dataset: dataset,
              neighborhood_radius: 10,
              learning_rate: 0.005,
              epochs: 100}

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
    step = 1
    if iteration == som.epochs-1 or iteration%step == 0
      som.neurons = Marshal.load(neurons)
      som.current_iteration = iteration
      Drawer.new(som: som, type: :rasem).draw
      #Drawer.new(som: som, type: :chunky).draw
      #Drawer.new(som: som, type: :rmagick).draw
    end
  end
}
