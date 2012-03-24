module GridType
  module Square
    include GridType

    def find_neighbors(neurons, data_item, radius)
      founded = {}
      for_found = [neurons.index(data_item)]

      old = [neurons.index(data_item)]

      #p 11111111
      #puts Benchmark.realtime {
      (1..radius).each do |r|
        founded[r] ||= []

        for_found.each do |index|

          _neighbors = neighbors(index)

          _neighbors -= old
          old = founded.values.flatten #.uniq
          founded[r] += _neighbors
        end
        for_found = founded[r]
      end
      #}
      founded.each do |_, value|
        value.uniq!
      end
      founded
    end

    def neighbors(index)
      #unless data_item.neighbors
      #  index = neurons.index(data_item)

      x, y = convert_to_coordinate index
      coordinates = [
         [x-1, y],
         [x+1, y],
         [x, y-1],
         [x, y+1]
      ]

      coordinates = coordinates.find_all { |coordinate| correct_coordinate? coordinate }
      #data_item.neighbors =
      coordinates.map { |c| convert_to_index c }
      #end
      #data_item.neighbors#.map { |i| neurons[i] }
    end
  end

  module Hexagonal
    # TODO need implementing
    def neighbors(neurons, index, radius)
      []
      #def neighbors(i, n=1)
      #  index = @neurons.index(i) if i.is_a?(Neuron)
      #  x, y = coordinate index
      #  array = []
      #  grouped_neurons.each_with_index do |col, col_ind|
      #    col.each_with_index do |value, row_ind|
      #      array << value if x == col_ind and [y-1, y+1].include? row_ind
      #      if [x-1, x+1].include? col_ind
      #        array << value if y == row_ind
      #        if (x%2) == 0
      #          array << value if y-1 == row_ind
      #        else
      #          array << value if y+1 == row_ind
      #        end
      #      end
      #    end
      #  end
      #  array
      #end
    end
  end

  module Line
    def neighbors(neurons, data_item, radius)
      return if radius == 0

      index = neurons.index(data_item)

      coordinates = [index-1, index+1]
      coordinates = coordinates.find_all { |coordinate| (0...neurons.size).include? coordinate }
      _neighbors = coordinates.map { |index| neurons[index] }

      sub_neighbors = _neighbors.map { |neighbor| neighbors(neurons, neighbor, radius-1) }.flatten
      ((_neighbors | sub_neighbors) - [data_item]).compact
    end
  end

  def convert_to_coordinate(index)
    x = (index / rows) % cols
    y = index % rows
    [x, y]
  end

  def convert_to_index(coordinate)
    x, y = coordinate
    (x*rows + y)
  end

  def correct_coordinate?(coordinate)
    (0...cols).include? coordinate[0] and (0...rows).include? coordinate[1]
  end
end