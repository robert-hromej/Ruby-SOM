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
    neighbors.map { |neighbor| distance neighbor }.sum
  end

  def neighbors_by_radius radius
    result = [[self]]

    (1..radius).each do
      sub_result = []

      result.last.each do |neuron|
        neuron.founded!
        filtered_neighbors = neuron.neighbors.find_all { |x| !x.founded? }
        filtered_neighbors.each { |neighbor| sub_result << neighbor }
        filtered_neighbors.each { |neighbor| neighbor.founded! }
      end

      result << sub_result
    end
    result.delete_if { |x| x == [] }
    result
  end

  def weights
    @weights ||= Array.new(dimension).map { rand }
  end

  def update! data_item, rate
    return if updated?

    self.weights = Math.update_weights(self.weights, data_item, rate)
  end

  def distance other_neuron
    Math.euclidean_distance weights, other_neuron.weights
  end

  def to_s
    "Neuron[#{weights.join(',')}]"
  end
end
