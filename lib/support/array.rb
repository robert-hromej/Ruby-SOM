require 'normalizer'

class Array
  def sum
    self.inject(0) { |s, v| s += v }
  end

  def normalize size = 1
    if size == 1
      map { |item| (item - min) / (max - min) }
    else
      _min, _max = Normalizer.find_min_and_max self
      normalizer = Normalizer.new(:min => _min, :max => _max)
      self.map { |n| normalizer.normalize(n) }
    end
  end

  def search index_list
    Array(index_list).map { |ind| self[ind] }
  end
end