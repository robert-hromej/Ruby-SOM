module GridType
  module Hexagonal
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
end