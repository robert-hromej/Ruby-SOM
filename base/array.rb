class Array
  def sum
    self.inject(0){|s, v| s += v}
  end
end