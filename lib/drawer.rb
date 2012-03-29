require 'color'

class Drawer
  attr_accessor :som, :width, :height, :type

  def initialize attributes = {}
    self.som = attributes[:som]
    self.type = attributes[:type]
  end

  def file_name
    dir = "output/#{som.file_name}"
    Dir.mkdir dir unless Dir.exist? dir
    "#{dir}/iteration_#{som.current_iteration}.#{format}"
  end

  def draw
    draw_ceils
    save_to_file file_name
    file_name
  end

  def colors
    cls = []
    normalized_distances.each do |distance|
      color = 256 - distance*256
      cls << Color::RGB.new(color, color, color).html
    end
    cls
  end

  private

  def save_to_file file_name
    case type
    when :rmagick
      canvas = Magick::Image.new som.grid.width, som.grid.height
      drawer.draw(canvas)
      canvas.write file_name
    when :chunky
      drawer.save file_name, :interlace => true, :compression => Zlib::NO_COMPRESSION
    when :rasem
      drawer.close
      File.open(file_name, "w") { |f| f << drawer.output }
    end
  end

  def drawer
    return @drawer if @drawer

    @drawer = case type
              when :rmagick then rmagick_drawer
              when :chunky then chunky_drawer
              when :rasem then rasem_drawer
              when :canvas then som.canvas
              else raise "unknown type '#{type}'"
              end
  end

  def draw_ceils
    normalized_distances.each_with_index do |distance, index|
      col, row = som.grid.convert_to_coordinate index
      polygon = create_polygon(col, row, distance)
      draw_polygon polygon
    end
  end

  def create_polygon(col, row, weight)
    color = 256 - weight*256
    color = Color::RGB.new(color, color, color).html

    polygon = som.grid.polygon_points col, row
    polygon << color
  end

  def draw_polygon polygon
    color = polygon.pop

    case type
    when :rmagick
      drawer.fill color
      drawer.polygon *polygon
    when :chunky
      drawer.polygon polygon.flatten, 0, color
    when :rasem
      drawer.polygon *(polygon << {fill: color})
    when :canvas
      polygon = TkcPolygon.new(drawer, *polygon, fill: color, tags: 'aaa bbb')
      p polygon.id
      p polygon.tags
      polygon.tags = 'zzz qqq'
      p polygon.tags
    end
  end

  def normalized_distances
    distances = som.neurons.map { |neuron| som.distance_with_neighbors neuron }
    min, max = distances.min, distances.max
    distances.map! { |distance| (distance - min) / (max - min) }
  end

  def rmagick_drawer
    require 'RMagick'
    self.extend Magick
    Magick::Draw.new
  end

  def chunky_drawer
    require 'chunky_png'
    ChunkyPNG::Image.new som.grid.width.ceil, som.grid.height.ceil
  end

  def rasem_drawer
    require 'rasem'
    Rasem::SVGImage.new som.grid.width.ceil, som.grid.height.ceil
  end

  def format
    case type
    when :rmagick then 'gif'
    when :chunky then 'png'
    when :rasem then 'svg'
    end
  end
end
