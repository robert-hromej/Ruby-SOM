module GridType
  def find_neighbors(neurons, data_item, radius)
    founded = Hash.new []
    for_found = [data_item]

    old = [data_item]

    (1..radius).each do |r|

      for_found.each do |neuron|
        _neighbors = neighbors(neurons, neuron)
        _neighbors -= old
        old |= founded.values.flatten
        founded[r] |= _neighbors
      end

      for_found = founded[r]
    end
    founded
  end

  def convert_to_coordinate index
    x = (index/rows)%cols
    y = index%rows
    [x, y]
  end

  def convert_to_index coordinate
    x, y = coordinate
    x*rows + y
  end

  def correct_coordinate? coordinate
    col, row = coordinate
    (0...cols).include? col and (0...rows).include? row
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