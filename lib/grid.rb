require 'digest/md5'

class Grid
  attr_accessor :type, :rows, :cols

  def initialize(_grid)
    self.type = _grid[:type]
    self.rows = _grid[:rows]
    self.cols = _grid[:cols]

    include_module
  end

  def size
    rows * cols
  end

  def draw(gc, data, width, height)
    draw_grid(gc, width-100, height-100)

    draw_ceils(gc, data, width-100, height-100)
  end

  def to_s
    "#{type}_#{rows}_#{cols}"
  end

  private

  #def draw_ceils(gc, data, width, height)
  #
  #  x = 50
  #  y = 50
  #
  #  width_scale = width.to_f / cols
  #  height_scale = height.to_f / rows
  #
  #  rows.times do |row|
  #    cols.times do |col|
  #
  #      index = convert_to_index [col, row]
  #
  #      _x = x + width_scale/2 + width_scale*col
  #      _y = y + height_scale/2 + height_scale*row
  #
  #      gc.circle(_x, _y, _x, _y+10)
  #    end
  #  end
  #end

  #def draw_grid(gc, width, height)
  #  lines(50, 50, width, height).each do |line|
  #    gc.line *line
  #  end
  #end
  #
  #def lines(x, y, width, height)
  #  array = []
  #
  #  (0..rows).each do |row|
  #    scale = row.to_f / rows
  #    array << [x, y + scale*height, x + width, y + scale*height]
  #  end
  #
  #  (0..cols).each do |col|
  #    scale = col.to_f / cols
  #    array << [x + scale*width, y, x + scale*width, y + height]
  #  end
  #
  #  array
  #end

  def include_module
    case type.to_sym
    when :square then
      self.extend GridType::Square
    when :hexagonal then
      self.extend GridType::Hexagonal
    else
      raise "unknown grid type '#{type}'"
    end
  end
end