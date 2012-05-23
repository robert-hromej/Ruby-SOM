require 'RMagick'
require 'color'

module Drawer
  attr_accessor :output_directory

  def draw output_directory, data_items = []
    prog_bar = ProgressBar.new("Drawing images", dataset.fields.size + 1)

    self.output_directory = output_directory

    draw_unified_distances data_items
    prog_bar.inc

    dataset.fields.each_index do |index|
      prog_bar.inc
      draw_properties index, data_items
    end

    prog_bar.finish
  end

  def draw_unified_distances data_items = []
    normalized_distances.each_with_index do |distance, index|
      fill distance, :rgb
      draw_polygon index
    end

    #set_data_item_flags data_items

    save_to_file file_path('unified')
  end

  def draw_properties property_index, data_items = []
    properties = normalized_properties.map { |property| property[property_index] }

    properties.each_with_index do |weight, index|
      fill weight, :hsl
      draw_polygon index
    end

    #set_data_item_flags data_items

    save_to_file file_path("property_#{property_index}")
  end

  private

  def file_path file_name = 'unified'
    "#{output_directory}/#{file_name}.gif"
  end

  def save_to_file file_path
    canvas = Magick::Image.new(grid.width, grid.height)
    drawer.draw(canvas)
    canvas.write file_path
    @drawer = nil
  end

  def drawer
    @drawer ||= Magick::Draw.new
  end

  def draw_polygon index
    polygon = grid.polygon index
    drawer.polygon *polygon
  end

  def fill weight, type
    drawer.fill gradient_color(weight, type)
  end

  def gradient_color weight, type
    scale = 1 - weight
    if type == :hsl
      Color::HSL.new(240*scale, 100, 50).html
    else
      Color::RGB.new(scale*256, scale*256, scale*256).html
    end
  end

  def normalized_distances
    neurons.map { |neuron| neuron.distance_with_neighbors }.normalize
  end

  def normalized_properties
    neurons.map { |neuron| neuron.weights }.normalize(2)
  end
end
