module GridType
  module Hexagonal
    SCALE = Math.sqrt(3)/2

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
      y = row * h + ceil_size# - 1

      [[x - ceil_size*SCALE, y + ceil_size/2],
       [x, y + ceil_size],
       [x + ceil_size*SCALE, y + ceil_size/2],
       [x + ceil_size*SCALE, y -ceil_size/2],
       [x, y - ceil_size],
       [x - ceil_size*SCALE, y -ceil_size/2]]
    end
  end
end