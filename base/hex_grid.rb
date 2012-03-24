## TODO need implementation!
#class HexGrid
#
#  attr_accessor :data, :rows, :cols
#
#  def initialize(data)
#    self.data = data
#  end
#
#  def neighbors(index)
#    x, y = coordinate index
#    array = []
#    grouped_neurons.each_with_index do |col, col_ind|
#      col.each_with_index do |value, row_ind|
#        array << value if x == col_ind and [y-1, y+1].include? row_ind
#        if [x-1, x+1].include? col_ind
#          array << value if y == row_ind
#          if (x%2) == 0
#            array << value if y-1 == row_ind
#          else
#            array << value if y+1 == row_ind
#          end
#        end
#      end
#    end
#    array
#  end
#
#  def length
#    lines.map do |line|
#      Math.euclidean_distance(line[0], line[1])
#    end.sum
#  end
#
#  def lines
#    ar = []
#    data.each_with_index do |object, index|
#      neighbors(index).each do |neighbor|
#        ar << [neighbor, d].sort
#      end
#    end
#    # TODO return array all lines beetwene neurones
#  end
#
#  def coordinate(index)
#    x = index % cols
#    y = (index / cols) % rows
#    [x, y]
#  end
#
#  def grouped_neurons
#    array = []
#    self.each_with_index do |value, index|
#      x = (index % cols)
#      array[x] ||= []
#      array[x] << value
#    end
#    array
#  end
#
#end
#
#
#grid = HexGrid.new([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
#
#grid.cols = 4
#grid.rows = 3
#
##p grid.coordinate(0)
##p grid.grouped_neurons
#
#
#(0..11).each do |i|
#  p i
#  p grid.neighbors(i)
#end
#
##p grid.neighbors(1)
##grid.neighbors 2
##grid.neighbors 3
##grid.neighbors 4
##grid.neighbors 5
##grid.neighbors 6
##grid.neighbors 7
##grid.neighbors 8
##grid.neighbors 9
##grid.neighbors 10
##grid.neighbors 11
#
##p grid