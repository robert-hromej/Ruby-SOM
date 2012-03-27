require 'set'

require './lib/som'
require './lib/grid'
require './lib/grid/square'
require './lib/dataset'
require './lib/neuron'

describe SOM do

  let(:grid) { Grid.new(type: :square, rows: 100, cols: 100) }

  let(:dataset) { './spec/datasets/eight_color.csv' }

  let(:attributes) { {grid: grid, dataset: dataset, neighborhood_radius: 23, learning_rate: 0.8, :epochs => 50} }

  subject { SOM.new attributes }

  it "should be correct variables" do
    subject.size.should eq 10000
    subject.neurons.size.should eq 10000
    subject.grid.should eq grid
    subject.epochs.should eq 50
    subject.neighborhood_radius.should eq 23
    subject.learning_rate.should eq 0.8
  end

  it "run train" do
    subject.should_receive(:train_epoch).exactly(50)
    subject.run_train
  end

  it "train_epoch" do
    subject.should_receive(:train_data_item).exactly(subject.dataset.data.size)
    #rate =  0.8 * (1 - 0.33423)
    subject.train_epoch 0.33423
  end

  it 'train_data_item'
  it 'distance_with_neighbors'
  it 'find_neuron_by_coordinate coordinate'

end