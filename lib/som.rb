require 'digest/md5'
#require 'benchmark'

class SOM
  attr_accessor :neighborhood_radius, :learning_rate, :epochs, :current_iteration
  attr_reader :grid, :dataset

  def initialize(attributes)
    self.grid = attributes[:grid]
    self.neighborhood_radius = attributes[:neighborhood_radius]
    self.learning_rate = attributes[:learning_rate]
    self.epochs = attributes[:epochs]
    self.dataset = attributes[:dataset]
  end

  def dataset=(_dataset)
    @dataset = _dataset.is_a?(Dataset) ? _dataset : Dataset.new(_dataset)
  end

  def history
    @history ||= {}
  end

  def self.load filepath
    data = File.open(filepath, 'rb') { |f| f.read }
    Marshal.load data
  end

  def file_name
    SOM.file_name self
  end

  def self.file_name _som
    if _som.is_a? SOM
      data_hash = Digest::MD5.hexdigest _som.dataset.data.to_s
      "#{_som.grid}_#{_som.learning_rate}_#{_som.neighborhood_radius}_#{_som.dataset.fields.size}_#{_som.epochs}_#{data_hash}"
    else
      dataset = Dataset.new _som[:dataset]
      data_hash = Digest::MD5.hexdigest dataset.data.to_s
      "#{_som[:grid][:type]}_#{_som[:grid][:rows]}_#{_som[:grid][:cols]}_#{_som[:learning_rate]}_#{_som[:neighborhood_radius]}_#{dataset.fields.size}_#{_som[:epochs]}_#{data_hash}"
    end
  end

  def save
    File.open("dump/#{file_name}.som", "w+") do |f|
      f.write Marshal.dump(self)
    end
  end

  def size
    self.grid.size
  end

  def grid=(_grid)
    @grid = _grid.is_a?(Grid) ? _grid : Grid.new(_grid)
  end

  def neurons
    return @neurons if @neurons

    @neurons ||= Array.new(size).map { Neuron.new(dataset.fields.size) }
    size.times do |index|
      neuron = @neurons[index]
      neighbors_index = grid.neighbors index
      neighbors_index.each { |neighbor_index| neuron.neighbors = @neurons[neighbor_index] }
    end
    @neurons
  end

  def neurons=(_neurons)
    @neurons = _neurons
  end

  def run_train
    epochs.times do |epoch|
      @current_iteration = epoch
      train_epoch epoch.to_f/epochs

      history[epoch] = Marshal.dump(self.neurons)
    end
  end

  def train_epoch epoch_rate
    puts epoch_rate
    rate = learning_rate * (1 - epoch_rate)

    #(10 - 1) / (100 * 0.65)
    #d_diff = (d - 1.0) / (n * 0.65)

    radius = [neighborhood_radius*(1-epoch_rate), 1].max
    dataset.normalized_data.each { |data_item| train_data_item(data_item, rate, radius) }
  end

  def train_data_item(data_item, rate, radius)
    neurons.each { |neuron| neuron.reset_updated_status }
    neurons.each { |n| n.reset_founded_status }

    rate_scale = radius.to_f + 1.0

    neuron = closest(data_item)

    neighbors = neuron.neighbors_by_radius radius
    neighbors.each do |ns|
      rate -= rate / rate_scale
      ns.each do |n|
        n.update!(data_item, rate)
      end
    end
  end

  def distance_with_neighbors neuron
    neuron.neighbors.map { |n| neuron.distance n }.sum
  end

  def find_neuron_by_coordinate coordinate
    index = grid.convert_to_index coordinate
    neurons[index]
  end

  private

  def closest(data_item)
    closest = nil
    closest_dist = nil
    @neurons.each do |neuron|
      distance = Math.euclidean_distance(data_item, neuron.weights)
      if closest.nil? or distance < closest_dist
        closest = neuron
        closest_dist = distance
      end
    end
    closest
  end
end
