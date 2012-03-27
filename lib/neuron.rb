class Neuron
  attr_accessor :dimension
  attr_writer :weights

  def initialize(dimension)
    self.dimension = dimension
  end

  def neighbors
    @neighbors ||= Set.new
  end

  def neighbors=(neurons)
    Array(neurons).each do |neuron|
      neighbors.add neuron
    end
  end

  def neighbors_by_radius radius
    self.already_founded!
    result = []
    for_found = [self]
    (1..radius).each do
      result << []

      for_found.each do |r|
        r.neighbors.to_a.find_all { |x| !x.already_founded? }.each do |neuron|
          result.last << neuron
          neuron.already_founded!
        end
      end

      for_found = result.last
    end
    result.delete_if{|x| x == []}
    result
  end

  def weights
    @weights ||= Array.new(dimension).map { rand }
  end

  def update! data_item, rate
    return if already_updated?
    raise "@weights.size != n.w.size" unless weights.size == data_item.size

    dimension.times { |i| weights[i] += rate * (data_item[i] - weights[i]) }
    self
  end

  def reset_updated_status
    @already_updated = false
  end

  def reset_founded_status
    @already_founded = false
  end

  def already_founded!
    @already_founded = true
  end

  def already_founded?
    !!@already_founded
  end

  def average_weight
    weights.sum / weights.size
  end

  def distance other_neuron
    Math.euclidean_distance weights, other_neuron.weights
  end

  def inspect
    "Neuron[#{weights.join(',')}]"
  end

  private

  def already_updated?
    !!@already_updated
  end

  def already_updated!
    @already_updated = true
  end
end
