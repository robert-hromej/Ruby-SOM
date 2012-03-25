module GridType
  def find_neighbors(neurons, data_item, radius)
    item_index =  neurons.index(data_item)
    
    founded = Hash.new []
    
    for_found = [item_index]
    old = [item_index]

    (1..radius).each do |r|

      for_found.each do |index|
        _neighbors = neighbors index
        _neighbors -= old
        old |= founded.values.flatten
        founded[r] += _neighbors
      end

      for_found = founded[r]
    end
    founded.each { |_, value| value.uniq! }
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

  def neighbors index
    x, y = convert_to_coordinate index
    coordinates = coordinate_matrix(x, y)

    coordinates = coordinates.find_all { |coordinate| correct_coordinate? coordinate }
    coordinates.map { |c| convert_to_index c }
  end
end