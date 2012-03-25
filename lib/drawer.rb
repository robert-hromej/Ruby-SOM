require 'color'

class Drawer
  attr_accessor :som, :width, :height, :type

  def initialize attributes
    self.som = attributes[:som]
    self.type = attributes[:type]
  end

  def file_name
    dir = "output/#{som.file_name}"
    Dir.mkdir dir unless Dir.exist? dir
    "#{dir}/iteration_#{som.current_iteration}.gif"
  end

  def self.create_animation dir, file_names
    animated = ImageList.new *file_names
    animated.delay = 100 / 5
    animated.ticks_per_second = 100 / 5
    animated.iterations = 1000
    animated.write("output/#{dir}/animated.gif")
  end

  def draw
    draw_ceils
    save_to_file file_name
    file_name
  end

  private

  def save_to_file file_name
    case type
    when :rmagick
      canvas = Magick::Image.new som.grid.width, som.grid.height
      drawer.draw(canvas)
      canvas.write file_name
    when :other
    end
  end

  def drawer
    return @drawer if @drawer

    @drawer = case type
              when :rmagick then  rmagick_drawer
              #when :rmagick then rmagick_drawer
              else raise "unknown type '#{type}'"
              end
  end

  def draw_ceils
    max_distance = 0
    min_distance = 0

    som.neurons.each do |neuron|
      distance = som.distance_with_neighbors neuron
      max_distance = distance if distance > max_distance
      min_distance = distance if distance < min_distance
    end

    som.grid.rows.times do |row|
      som.grid.cols.times do |col|
        neuron = som.find_neuron_by_coordinate [col, row]
        distance = som.distance_with_neighbors neuron
        weight = (distance - min_distance) / (max_distance - min_distance)
        draw_ceil col, row, weight
      end
    end
  end

  def draw_ceil col, row, weight
    #a = (0..2).to_a.map{ |i| neuron.weights[i]*256 }
    #
    #color = a.map{|c| (c == a.max) ? (256 - c*weight) : 0 }
    #
    #draw.fill  Color::RGB.new(*color).html

    #p weight
    #color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
    #draw.fill color

    color = 256 - weight*256
    drawer.fill Color::RGB.new(color, color, color).html

    coordinates = som.grid.ceil_polygon col, row
    drawer.polygon *coordinates
  end

  #def draw_neurons_square
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
  #      index = som.grid.convert_to_index [col, row]
  #      neuron = som.neurons[index]
  #
  #      distance = som.distance_with_neighbors neuron
  #
  #      weight = (distance - min_distance) / (max_distance - min_distance)
  #
  #      #a = (1..3).to_a.map{ |i| neuron.weights[i]*256 }
  #      #color = a.map{|c| (c == a.max) ? (256 - c*weight) : 0 }
  #      #draw.fill  Color::RGB.new(*color).html
  #
  #      #p weight
  #      #color = "##{"%06x" % (0xffffff - weight*0xffffff)}"
  #      #draw.fill color
  #
  #      color = 256 - weight*256
  #      draw.fill Color::RGB.new(color, color, color).html
  #    end
  #  end
  #end


  def rmagick_drawer
    require 'RMagick'
    self.extend Magick
    Magick::Draw.new
  end
end