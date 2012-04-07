class SomManager
  class << self

    def open file_path
      file = File.open(file_path, 'rb') { |f| f.read }
      data = Marshal.load file
      load(data)
    end

    def save som, file_path
      File.open(file_path, "w+") do |f|
        f.write Marshal.dump dump(som)
      end
    end

    private

    def dump object
      result = {}
      if object.is_a? SOM
        result = {:neighborhood_radius => object.neighborhood_radius,
                  :learning_rate => object.learning_rate,
                  :epochs => object.epochs,
                  :dataset => object.dataset,
                  :grid => object.grid,
                  :neurons => object.neurons.map { |neuron| dump(neuron) }
        }
      end

      if object.is_a? Neuron
        result = {:weights => object.weights}
      end
      result
    end

    def load data
      neurons = data.delete(:neurons)

      som = SOM.new data

      som.neurons.each_with_index do |neuron, index|
        neuron.weights = neurons[index][:weights]
      end

      som
    end
  end
end