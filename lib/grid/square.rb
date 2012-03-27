module GridType
  module Square
    def coordinate_matrix(x, y)
      [[x-1, y], [x+1, y], [x, y-1], [x, y+1]]
    end

    def width
      ceil_size * cols
    end

    def height
      ceil_size * rows
    end

    def polygon_points col, row
      x, y = [col*ceil_size, row*ceil_size]
      [[x, y], [x+ceil_size, y], [x+ceil_size, y+ceil_size], [x, y+ceil_size],]
    end
  end
end