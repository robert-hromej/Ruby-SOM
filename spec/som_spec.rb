require './som/som'
require './som/grid'

describe SOM do

  let(:grid) { Grid.new(type: :square, rows: 100, cols: 100) }
  let(:data) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }
  let(:attributes) { {dimension: 3, size: 100, grid: grid, data: data, neighborhood_radius: 3, learning_rate: 0.8} }

  subject { SOM.new attributes }

  it "should be correct variables" do
    subject.dimension.should eq 3
    subject.size.should eq 100
    subject.neurons.size.should eq 100
    subject.grid.should eq grid
    subject.data.should eq data
    subject.neighborhood_radius.should eq 3
    subject.learning_rate.should eq 0.8
  end

  it "run train" do
    subject.should_receive(:train_epoch).exactly(100)
    subject.run_train(100)
  end

  it "train_epoch" do
    subject.should_receive(:train_data_item).exactly(data.size)
    #rate =  0.8 * (1 - 0.33423)
    subject.train_epoch 0.33423
  end

  it "train_data_item" do
    #def train_data_item(data_item, rate)
    neurons.each { |neuron| neuron.reset_updated_status }

    neuron = closest(data_item)
    neuron.update!(data_item, rate)

    all_neighbors = grid.find_neighbors(neurons, neuron, neighborhood_radius)

    all_neighbors.each do |radius, neighbors|
      rate -= rate / (all_neighbors.size.to_f + 1.0)
      neighbors.each { |neighbor| neighbor.update!(data_item, rate) }
    end




    subject.train_data_item(data[0], 0.33423)
  end

  #it "should be weights size" do
  #  subject.weights.size.should eq 3
  #end
  #
  #it "update! method" do
  #  c = [0.2, 0.5, 0.1]
  #  a = 0.12
  #
  #  old_weights = subject.weights
  #
  #  new_weights = (0..3).to_a.map { |i| old_weights[i] + a*(c[i] - old_weights[i]) }
  #
  #  subject.update!(c, a)
  #
  #  subject.weights.should eq new_weights
  #end
end