module GridMap
  SCALE = Math.sqrt(3)/2

  def neighbors index
    x, y = convert_to_coordinate index
    coordinates = coordinate_matrix(x, y)

    coordinates = coordinates.find_all { |coordinate| correct_coordinate? coordinate }
    coordinates.map { |c| convert_to_index c }
  end

  def polygon index
    col, row = convert_to_coordinate index
    polygon_points(col, row)
  end

  def coordinate_matrix(x, y)
    i = (x%2 == 0) ? 1 : -1
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1], [x-1, y+i], [x+1, y+i]]
  end

  def width
    2*SCALE*ceil_size*(cols + 0.5)
  end

  def height
    ceil_size*(1.5*rows + 0.5)
  end

  def polygon_points col, row
    w = 2 * ceil_size * SCALE
    h = 1.5 * ceil_size

    x = col * w + (row%2 == 0 ? 0 : ceil_size*SCALE) + ceil_size*SCALE
    y = row * h + ceil_size # - 1

    [[x - ceil_size*SCALE, y + ceil_size/2],
     [x, y + ceil_size],
     [x + ceil_size*SCALE, y + ceil_size/2],
     [x + ceil_size*SCALE, y -ceil_size/2],
     [x, y - ceil_size],
     [x - ceil_size*SCALE, y -ceil_size/2]]
  end

  private

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
end