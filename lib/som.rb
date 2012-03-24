require 'normalizer'
require 'digest/md5'

require 'benchmark'

class SOM
  attr_accessor :dimension, :neighborhood_radius, :learning_rate, :epochs
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

  def hash_name
    name = {:dimension => dimension,
            :data => data,
            :neighborhood_radius => neighborhood_radius,
            :learning_rate => learning_rate,
            :grid => grid.hash_name,
            :epochs => epochs}
    Digest::MD5.hexdigest name.to_s
  end

  def save # filepath
    filepath = hash_name
    if filepath
      File.open(filepath, "w+") do |f|
        f.write Marshal.dump(self)
      end
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

  def run_train
    epochs.times do |epoch|
      puts "def run_train"
      puts Benchmark.realtime { train_epoch epoch.to_f/epochs }
      #puts Benchmark.realtime { yield epoch }
      yield epoch
    end
  end

  def train_epoch(epoch_rate)
    puts epoch_rate
    rate = learning_rate * (1 - epoch_rate)

    (10 - 1) / (100 * 0.65)

    #d_diff = (d - 1.0) / (n * 0.65)

    radius = [neighborhood_radius*(1-epoch_rate), 1].max

    normalized_data.each { |data_item| train_data_item(data_item, rate, radius) }
    #sleep 5
  end

  def train_data_item(data_item, rate, radius)

    #p "def train_data_item(data_item, rate, radius)"

    neurons.each { |neuron| neuron.reset_updated_status }

    neuron = nil
    #puts Benchmark.realtime {
      neuron = closest(data_item)
    #}

    neuron.update!(data_item, rate)

    #all_neighbors = nil
    #puts Benchmark.realtime {
      all_neighbors = neighbors(neuron, radius)
    #}

    #puts Benchmark.realtime {
    all_neighbors.each do |_, neighbors|
      rate -= rate / (all_neighbors.size.to_f + 1.0)
      neighbors.each do |index|
        neighbor = neurons[index]
        neighbor.update!(data_item, rate)
      end
    end
    #}
  end

  def neighbors neuron, radius = nil
    radius ||= neighborhood_radius
    grid.find_neighbors(neurons, neuron, radius.to_i)
  end

  def distance_with_neighbors neuron
    distance = 0
    neighbors = neighbors neuron, 1
    neighbors.each do |_, neighbor|
      neighbor.each do |index|
        distance += neuron.distance neurons[index]
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
