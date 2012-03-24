class Neuron
  attr_accessor :dimension, :neighbors
  attr_writer :weights

  def initialize(dimension)
    self.dimension = dimension
  end

  #def neighbors
  #  #return nil unless @neighbors
  #
  #  @neighbors
  #end
  #
  #def neighbors=(indexes)
  #  @neighbors = indexes
  #end

  def weights
    @weights ||= Array.new(dimension).map { rand }
  end

  def update!(data_item, rate)
    return if already_updated?
    raise "@weights.size != n.w.size" unless weights.size == data_item.size

    dimension.times { |i| weights[i] += rate * (data_item[i] - weights[i]) }
  end

  def reset_updated_status
    @already_updated = false
  end

  def average_weight
    weights.inject(0){ |sum, w| sum += w }/weights.size
  end

  def distance other_neuron
    Math.euclidean_distance self.weights, other_neuron.weights
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

  # TODO dont need this merhod
  #def move_close_to(n)
  #  raise "@weights.size != n.w.size" unless weights.size == n.w.size
  #
  #  dimension.times { |i| weights[i] = n.w[i] + (0.01 * (rand-0.5)) }
  #end
end
