require 'progressbar'

require './lib/drawer'
#
require 'benchmark'

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

  def classify
    neurons.each { |neuron| neuron.buckets = [] }

    dataset.normalized_data.each do |data_item|
      closest_neuron = closest data_item
      closest_neuron.buckets << data_item
    end

    result = {}

    neurons.each_with_index do |neuron, index|
      coordinate = grid.send(:convert_to_coordinate, index)
      result[coordinate] = neuron.buckets unless neuron.buckets.empty?
    end

    result
  end

  def neurons
    return @neurons if @neurons

    @neurons ||= Array.new(size).map { Neuron.new(dataset.fields.size) }
    update_neuron_neighbors
    @neurons
  end

  def run_train
    prog_bar = ProgressBar.new("Training", epochs)

    epochs.times do |epoch|
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

    neighbors = closest_neuron.neighbors_by_radius radius

    neighbors.each do |ns|
      ns.each do |neuron|
        neuron.update!(data_item, rate)
      end
      rate -= rate / rate_scale
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
    #weights = neurons.map { |neuron| neuron.weights }
    #index = Math.closest(weights, data_item)

    distances = neurons.map { |neuron| Math.euclidean_distance(data_item, neuron.weights) }

    min = distances.min
    index = distances.index(min)

    neurons[index]
  end
end
