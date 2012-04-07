require 'digest/md5'
require './lib/grid/grid_map'

def Grid(grid)
  grid.is_a?(Grid) ? grid : Grid.new(grid)
end

class Grid
  include GridMap

  attr_accessor :rows, :cols, :ceil_size

  def initialize(attributes)
    self.rows = attributes[:rows]
    self.cols = attributes[:cols]
    self.ceil_size = attributes[:ceil_size]
  end

  def size
    rows * cols
  end

  def to_s
    "#{rows}_#{cols}"
  end
end