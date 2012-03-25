module GridType
  module Square
    def coordinate_matrix(x, y)
      [
         [x-1, y],
         [x+1, y],
         [x, y-1],
         [x, y+1]
      ]
    end
  end
end