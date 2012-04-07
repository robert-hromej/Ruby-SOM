require './lib/support/status_attr'

class Neuron
  attr_accessor :dimension
  attr_writer :weights
  status_attr :updated, :founded

  def initialize dimension
    self.dimension = dimension
  end

  def neighbors
    @neighbors ||= []
  end

  def neighbors=(neurons)
    @neighbors = Array(neurons)
  end

  def distance_with_neighbors
    neighbors.map { |neighbor| self.distance neighbor }.sum
  end

  def neighbors_by_radius radius
    self.founded!

    result = []

    for_found = [self]

    (1..radius).each do
      result << []

      for_found.each do |r|
        r.neighbors.to_a.find_all { |x| !x.founded? }.each do |neuron|
          result.last << neuron
          neuron.founded!
        end
      end

      for_found = result.last
    end
    result.delete_if { |x| x == [] }
    result
  end

  def weights
    @weights ||= Array.new(dimension).map { rand }
  end

  def update! data_item, rate
    return if updated?
    raise "@weights.size != n.w.size" unless weights.size == data_item.size

    dimension.times { |i| weights[i] += rate * (data_item[i] - weights[i]) }
    self
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
end
