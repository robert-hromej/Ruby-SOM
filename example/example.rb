#require "bundler"
#Bundler.require

require './base/math'

require './lib/som'
require './lib/neuron'
require './lib/grid/grid_type'
require './lib/grid'
require './lib/drawer'

#require './datasets/three_color'
require './datasets/eight_color'
#require './datasets/iris'
#require './datasets/cows'

Dir.mkdir 'output' unless Dir.exist? 'output'

som_file = ''

if File.exist? som_file
  som = SOM.load som_file
else

  grid = Grid.new(:type => :square, :rows => 50, :cols => 50)

  attributes = {:dimension => DIMENSION,
                :grid => grid,
                :data => DATA_SET,
                :neighborhood_radius => 25,
                :learning_rate => 0.1,
                :epochs => 500}

  som = SOM.new attributes

  file_names = []

  ceil_size = 5

  som.run_train do |epoch|
    if epoch%5 == 0 or epoch == 499
      drawer = Drawer.new(:width => som.grid.cols*ceil_size, :height => som.grid.rows*ceil_size, :som => som)
      file_names << "output/epoch_#{epoch+1}.gif"
      drawer.save "output/epoch_#{epoch+1}.gif"
    end
  end

  Drawer.create_animation file_names

  #som.save
end

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

