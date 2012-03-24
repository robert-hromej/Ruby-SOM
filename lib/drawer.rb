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

  def save file_name
    draw_grid
    draw_neurons
    save_to_file file_name
  end

  def self.create_animation file_names
    animated = ImageList.new *file_names
    animated.delay = 100 / 3
    animated.ticks_per_second = 100 / 3
    animated.iterations = 1000
    animated.write("output/animated.gif")
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

  def draw_neurons
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

        #color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
        #draw.fill color

        color = 256 - weight*256
        draw.fill  Color::RGB.new(color, color, color).html

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
