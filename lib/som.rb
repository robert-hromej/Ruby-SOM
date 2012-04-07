require 'progressbar'

require './lib/drawer'

class SOM
  include Drawer

  attr_accessor :neighborhood_radius, :learning_rate, :epochs, :progressbar, :dataset, :grid

  def initialize attributes = {}
    self.grid = Grid(attributes[:grid])
    self.neighborhood_radius = attributes[:neighborhood_radius]
    self.learning_rate = attributes[:learning_rate]
    self.epochs = attributes[:epochs]
    self.dataset = Dataset(attributes[:dataset])
  end

  def size
    grid.size
  end

  def neurons
    return @neurons if @neurons

    @neurons ||= Array.new(size).map { Neuron.new(dataset.fields.size) }
    update_neuron_neighbors
    @neurons
  end

  def run_train
    prog_bar = ProgressBar.new("Training", epochs)

    (0..epochs).each do |epoch|
      prog_bar.inc
      train_epoch epoch
    end

    prog_bar.finish
  end

  def train_epoch epoch
    epoch_rate = epoch/epochs.to_f

    rate = learning_rate * (1 - epoch_rate)

    #(10 - 1) / (100 * 0.65)
    #d_diff = (d - 1.0) / (n * 0.65)

    radius = [neighborhood_radius*(1-epoch_rate), 1].max

    dataset.normalized_data.each do |data_item|
      neurons.each { |neuron| neuron.not_updated! }
      neurons.each { |n| n.not_founded! }

      train_data_item(data_item, rate, radius)
    end
  end

  def train_data_item(data_item, rate, radius)
    rate_scale = radius + 1.0

    closest_neuron = closest(data_item)
    closest_neuron.update!(data_item, rate)

    neighbors = closest_neuron.neighbors_by_radius radius
    neighbors.each do |ns|
      rate -= rate / rate_scale
      ns.each { |neuron| neuron.update!(data_item, rate) }
    end
  end

  private

  def update_neuron_neighbors
    neurons.each { |neuron| neuron.neighbors = [] }

    neurons.each_with_index do |neuron, index|
      neighbors = neurons.search grid.neighbors(index)
      neuron.neighbors = neighbors
    end
  end

  def closest(data_item)
    distances = @neurons.map { |neuron| Math.euclidean_distance(data_item, neuron.weights) }

    min = distances.min
    index = distances.index(min)

    @neurons[index]
  end
end
