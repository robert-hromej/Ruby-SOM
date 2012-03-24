module Math
  def self.euclidean_distance(point1, point2)
    dist = 0.0
    point1.each_with_index do |value, index|
      dist += (value - point2[index])**2
    end
    #dist
    Math.sqrt(dist)
  end
end