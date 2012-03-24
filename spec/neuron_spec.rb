require './som/neuron'

describe Neuron do

  subject { Neuron.new(3) }

  it "should be dimension" do
    subject.dimension.should eq 3
  end

  it "should be weights size" do
    subject.weights.size.should eq 3
  end

  it "update! method" do
    c = [0.2, 0.5, 0.1]
    a = 0.12

    old_weights = subject.weights

    new_weights = (0..2).to_a.map { |i| old_weights[i] + a*(c[i] - old_weights[i]) }

    subject.update!(c, a)

    subject.weights.should eq new_weights
  end
end