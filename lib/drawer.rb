require 'RMagick'
require 'color'
include Magick

# TODO need code review
class Drawer
  attr_accessor :width, :height, :som

  def initialize(attributes)
    self.width = attributes[:width]
    self.height = attributes[:height]
    self.som = attributes[:som]
  end

  def save
    dir = "output/#{som.file_name}"
    Dir.mkdir dir unless Dir.exist? dir
    #draw_grid

    draw_neurons_hexagonal if som.grid.type == :hexagonal
    draw_neurons_square if som.grid.type == :square

    file_name = "#{dir}/iteration_#{som.current_iteration}.gif"
    save_to_file file_name
    file_name
  end

  def self.create_animation dir, file_names
    animated = ImageList.new *file_names
    animated.delay = 100 / 5
    animated.ticks_per_second = 100 / 5
    animated.iterations = 1000
    animated.write("output/#{dir}/animated.gif")
  end

  private

  def save_to_file file_name
    hatch_fill = Magick::HatchFill.new('white', 'lightcyan2')
    canvas = Magick::Image.new(width, height, hatch_fill)
    draw.draw(canvas)
    canvas.write file_name
  end

  def draw
    @draw ||= Magick::Draw.new
  end

  def draw_grid
    grid_lines.each { |line| draw.line *line }
  end

  def grid_lines
    rows = som.grid.rows
    cols = som.grid.cols

    horizontal_lines = (0..rows).map { |row|
      scale = row.to_f / rows
      [0, scale*height, width, scale*height]
    }

    vertical_lines = (0..cols).map do |col|
      scale = col.to_f / cols
      [scale*width, 0, scale*width, height]
    end

    horizontal_lines | vertical_lines
  end

  def draw_neurons_hexagonal
    rows = som.grid.rows
    cols = som.grid.cols

    #raise "incorrect ceil size" unless width.to_f/cols == height.to_f/rows

    scale = (cols*54*2+54)/width.to_f

    max_distance = 0
    min_distance = 0

    som.neurons.each do |neuron|
      distance = som.distance_with_neighbors neuron
      max_distance = distance if distance > max_distance
      min_distance = distance if distance < min_distance
    end

    rows.times do |row|
      cols.times do |col|
        index = som.grid.convert_to_index [col, row]
        neuron = som.neurons[index]

        distance = som.distance_with_neighbors neuron

        weight = (distance - min_distance) / (max_distance - min_distance)

        #a = (0..2).to_a.map{ |i| neuron.weights[i]*256 }
        #
        #color = a.map{|c| (c == a.max) ? (256 - c*weight) : 0 }
        #
        #draw.fill  Color::RGB.new(*color).html

        #p weight
        #color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
        #draw.fill color

        color = 256 - weight*256
        draw.fill Color::RGB.new(color, color, color).html

        x = col*54*2 + (row%2 == 1 ? 0 : 54)
        y = row*93.8

        coordinates = [54+x, 0.0+y, 108+x, 31.25+y, 108+x, 93.75+y, 54+x, 125.0+y, 0+x, 93.8+y, 0+x, 31.25+y]
        coordinates.map!{ |c|  c.to_f / scale }
        draw.polygon *coordinates
      end
    end
  end

  def draw_neurons_square
    rows = som.grid.rows
    cols = som.grid.cols

    raise "incorrect ceil size" unless width.to_f/cols == height.to_f/rows

    scale = height.to_f/rows

    max_distance = 0
    min_distance = 0

    som.neurons.each do |neuron|
      distance = som.distance_with_neighbors neuron
      max_distance = distance if distance > max_distance
      min_distance = distance if distance < min_distance
    end

    rows.times do |row|
      cols.times do |col|
        index = som.grid.convert_to_index [col, row]
        neuron = som.neurons[index]

        distance = som.distance_with_neighbors neuron

        weight = (distance - min_distance) / (max_distance - min_distance)

        #a = (1..3).to_a.map{ |i| neuron.weights[i]*256 }
        #
        #color = a.map{|c| (c == a.max) ? (256 - c*weight) : 0 }
        #
        #draw.fill  Color::RGB.new(*color).html

        #p weight
        #color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
        #draw.fill color

        color = 256 - weight*256
        draw.fill Color::RGB.new(color, color, color).html

        draw.rectangle(scale*col, scale*row, scale*(col+1), scale*(row+1))
      end
    end
  end

  #def draw_neurons_old
  #  rows = som.grid.rows
  #  cols = som.grid.cols
  #
  #  raise "incorrect ceil size" unless width.to_f/cols == height.to_f/rows
  #
  #  scale = height.to_f/rows
  #
  #  max_distance = 0
  #  min_distance = 0
  #
  #  som.neurons.each do |neuron|
  #    distance = som.distance_with_neighbors neuron
  #    max_distance = distance if distance > max_distance
  #    min_distance = distance if distance < min_distance
  #  end
  #
  #  rows.times do |row|
  #    cols.times do |col|
  #
  #      index = som.grid.convert_to_index [col, row]
  #
  #      neuron = som.neurons[index]
  #
  #      distance = som.distance_with_neighbors neuron
  #
  #      weight = (distance - min_distance) / (max_distance - min_distance)
  #      #weight = neuron.average_weight
  #
  #      radius = weight*scale / 2
  #
  #      x = scale/2 + scale*col
  #      y = scale/2 + scale*row
  #
  #      draw.circle(x, y, x, y + radius)
  #    end
  #  end
  #end
end
