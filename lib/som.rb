require 'normalizer'
require 'digest/md5'

class SOM
  attr_accessor :dimension, :neighborhood_radius, :learning_rate, :epochs, :current_iteration
  attr_reader :grid, :data

  def initialize(attributes)
    self.dimension = attributes[:dimension]
    self.grid = attributes[:grid]
    self.data = attributes[:data]
    self.neighborhood_radius = attributes[:neighborhood_radius]
    self.learning_rate = attributes[:learning_rate]
    self.epochs = attributes[:epochs]
  end

  def data=(_data)
    @normalized_data = nil
    @data = _data
  end

  def history
    @history ||= {}
  end

  def normalized_data
    return @normalized_data if @normalized_data

    min, max = Normalizer.find_min_and_max(data)
    normalizer = Normalizer.new(:min => min, :max => max)
    @normalized_data = data.map { |n| normalizer.normalize(n) }
  end

  def self.load filepath
    data = ""
    File.open(filepath) do |f|
      while line = f.gets
        data << line
      end
    end
    Marshal.load(data)
  end

  def file_name
    SOM.file_name self
  end

  def self.file_name _som
    if _som.is_a? SOM
      data_hash = Digest::MD5.hexdigest _som.data.to_s
      "#{_som.grid}_#{_som.learning_rate}_#{_som.neighborhood_radius}_#{_som.dimension}_#{_som.epochs}_#{data_hash}"
    else
      data_hash = Digest::MD5.hexdigest _som[:data].to_s
      "#{_som[:grid][:type]}_#{_som[:grid][:rows]}_#{_som[:grid][:cols]}_#{_som[:learning_rate]}_#{_som[:neighborhood_radius]}_#{_som[:dimension]}_#{_som[:epochs]}_#{data_hash}"
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
    @neurons ||= Array.new(size).map { Neuron.new(dimension) }
  end

  def neurons=(n)
    @neurons = n
  end

  def run_train
    epochs.times do |epoch|
      @current_iteration = epoch
      train_epoch epoch.to_f/epochs

      history[epoch] = Marshal.dump(self.neurons)
    end
  end

  def train_epoch(epoch_rate)
    puts epoch_rate
    rate = learning_rate * (1 - epoch_rate)

    (10 - 1) / (100 * 0.65)

    #d_diff = (d - 1.0) / (n * 0.65)

    radius = [neighborhood_radius*(1-epoch_rate), 1].max

    normalized_data.each { |data_item| train_data_item(data_item, rate, radius) }
  end

  def train_data_item(data_item, rate, radius)
    neurons.each { |neuron| neuron.reset_updated_status }

    neuron = closest(data_item)
    neuron.update!(data_item, rate)

    all_neighbors = neighbors(neuron, radius)

    all_neighbors.each do |_, neighbors|
      rate -= rate / (all_neighbors.size.to_f + 1.0)
      neighbors.each do |neighbor|
        neighbor.update!(data_item, rate)
      end
    end
  end

  def neighbors neuron, radius = nil
    radius ||= neighborhood_radius
    grid.find_neighbors(neurons, neuron, radius.to_i)
  end

  def distance_with_neighbors neuron
    distance = 0
    neighbors = neighbors neuron, 1
    neighbors.each do |_, neighbor|
      neighbor.each do |n|
        distance += neuron.distance(n)
      end
    end
    distance
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
