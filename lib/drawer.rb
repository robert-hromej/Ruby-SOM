require 'color'
require 'rasem'

class Drawer
  attr_accessor :width, :height, :som

  def initialize(attributes)
    self.width = attributes[:width]
    self.height = attributes[:height]
    self.som = attributes[:som]
  end

  def rasem
    @rasem ||= Rasem::SVGImage.new width, height
  end

  def close_rasem!
    @rasem.close
  end

  def rasem_opened?
    !!@rasem
  end

  def save
    draw_neurons_hexagonal if som.grid.type == :hexagonal
    draw_neurons_square if som.grid.type == :square

    save_to_file file_name
    file_name
  end

  def file_name
    dir = "output/#{som.file_name}"
    Dir.mkdir dir unless Dir.exist? dir
    "#{dir}/iteration_#{som.current_iteration}.svg"
  end

  #def self.create_animation dir, file_names
  #  animated = ImageList.new *file_names
  #  animated.delay = 100 / 5
  #  animated.ticks_per_second = 100 / 5
  #  animated.iterations = 1000
  #  animated.write("output/#{dir}/animated.gif")
  #end

  private

  def save_to_file file_name
    return "rasem don't opened!!" unless rasem_opened?

    close_rasem!
    File.open(file_name, "w") { |f| f << rasem.output }
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

        #color = 256 - weight*256
        #draw.fill Color::RGB.new(color, color, color).html

        x = col*54*2 + (row%2 == 1 ? 0 : 54)
        y = row*93.8

        coordinates = [54+x, 0.0+y, 108+x, 31.25+y, 108+x, 93.75+y, 54+x, 125.0+y, 0+x, 93.8+y, 0+x, 31.25+y]
        coordinates.map! { |c| c.to_f / scale }

        #draw.polygon *coordinates

        color = 256 - weight*256
        coordinates << {fill: Color::RGB.new(color, color, color).html}
        rasem.polygon *coordinates
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
        color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
        draw.fill color

        color = 256 - weight*256
        #draw.fill Color::RGB.new(color, color, color).html

        rasem.rectangle(scale*col, scale*row, scale*(col+1), scale*(row+1))
      end
    end
  end
end
