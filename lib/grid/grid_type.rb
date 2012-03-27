module GridType

  def convert_to_coordinate index
    x = (index/rows)%cols
    y = index%rows
    [x, y]
  end

  def convert_to_index coordinate
    x, y = coordinate
    x*rows + y
  end

  def neighbors index
    x, y = convert_to_coordinate index
    coordinates = coordinate_matrix(x, y)

    coordinates = coordinates.find_all { |coordinate| correct_coordinate? coordinate }
    coordinates.map { |c| convert_to_index c }
  end

  private

  def correct_coordinate? coordinate
    col, row = coordinate
    (0...cols).include? col and (0...rows).include? row
  end
end