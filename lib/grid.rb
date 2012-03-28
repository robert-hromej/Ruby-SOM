require 'digest/md5'
require './lib/grid/grid_type'

# TODO need test
class Grid
  attr_accessor :rows, :cols, :ceil_size
  attr_reader :type
  include GridType

  def initialize(_grid)
    self.type = _grid[:type]
    self.rows = _grid[:rows]
    self.cols = _grid[:cols]
    self.ceil_size = _grid[:ceil_size]

    #include_module
  end

  def type=(_type)
    @type = _type
    #p @type
    include_module
  #  p coordinate_matrix(1, 2)
  #rescue
  end

  def size
    rows * cols
  end

  def to_s
    "#{type}_#{rows}_#{cols}"
  end

  private

  def include_module
    return if type.nil?

    case type.to_sym
    when :square then
      self.extend GridType::Square
    when :hexagonal then
      self.extend GridType::Hexagonal
      #else
      #  raise "unknown grid type '#{type}'"
    end
  end
end