module GridType
  module Square
    include GridType
    def coordinate_matrix(x, y)
      [
         [x-1, y],
         [x+1, y],
         [x, y-1],
         [x, y+1]
      ]
    end
  end

  module Hexagonal
    include GridType
    def coordinate_matrix(x, y)
      i = (x%2 == 0) ? 1 : -1
      [
         [x-1, y],
         [x+1, y],
         [x, y-1],
         [x, y+1],
         [x-1, y+i],
         [x+1, y+i]
      ]
    end
  end

  def find_neighbors(neurons, data_item, radius)
    founded = {}
    for_found = [data_item]

    old = [data_item]

    (1..radius).each do |r|

      founded[r] ||= []

      for_found.each do |neuron|
        _neighbors = neighbors(neurons, neuron)
        _neighbors -= old
        old = founded.values.flatten.uniq
        founded[r] |= _neighbors
      end

      for_found = founded[r]
    end
    founded
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

  def neighbors(neurons, data_item)
    index = neurons.index(data_item)

    x, y = convert_to_coordinate index

    coordinates = coordinate_matrix(x, y)

    coordinates = coordinates.find_all { |coordinate| correct_coordinate? coordinate }
    indexes = coordinates.map { |c| convert_to_index c }

    indexes.map { |index| neurons[index] }
  end
end