require './spec/spec_helper'

describe SOM do

  let(:grid) { Grid.new(:rows => 30, :cols => 30, :ceil_size => 15) }

  let(:dataset) { './spec/datasets/eight_color.csv' }

  let(:attributes) { {:grid => grid,
                      :dataset => dataset,
                      :neighborhood_radius => 20,
                      :learning_rate => 0.5,
                      :epochs => 100} }

  subject { SOM.new attributes }

  it "should be correct variables" do
    subject.size.should eq 900
    subject.neurons.size.should eq 900
    subject.grid.should eq grid
    subject.epochs.should eq 100
    subject.neighborhood_radius.should eq 20
    subject.learning_rate.should eq 0.5
  end

  it "run train" do
    subject.should_receive(:train_epoch).exactly(100)
    subject.run_train
  end

  it "train_epoch" do
    subject.should_receive(:train_data_item).exactly(subject.dataset.data.size)
    #rate =  0.8 * (1 - 0.33423)
    subject.train_epoch 0.33423
  end

  it 'draw' do
    subject.run_train
    Dir.mkdir './spec/tmp' unless Dir.exist? './spec/tmp'
    subject.draw './spec/tmp'
  end

  it 'train_data_item'
  it 'distance_with_neighbors'
  it 'find_neuron_by_coordinate coordinate'
end