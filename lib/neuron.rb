class Neuron
  attr_accessor :dimension
  attr_writer :weights

  def initialize(dimension)
    self.dimension = dimension
  end

  def weights
    @weights ||= Array.new(dimension).map { rand }
  end

  def update!(data_item, rate)
    return if already_updated?
    raise "@weights.size != n.w.size" unless weights.size == data_item.size

    dimension.times { |i| weights[i] += rate * (data_item[i] - weights[i]) }
    self
  end

  def reset_updated_status
    @already_updated = false
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
