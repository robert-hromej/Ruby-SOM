require 'digest/md5'

class Grid
  attr_accessor :type, :rows, :cols
  include GridType

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