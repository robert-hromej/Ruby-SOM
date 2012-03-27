require './lib/neuron'
require 'set'

require 'benchmark'

describe Neuron do

  subject { Neuron.new(3) }

  it "should be dimension" do
    subject.dimension.should eq 3
  end

  it "should be weights size" do
    subject.weights.size.should eq 3
  end

  context 'neighbors' do

    let(:neurons) { (1..6).map { |id| Neuron.new(id) } }

    before(:each) do
      @n1, @n2, @n3, @n4, @n5, @n6 = neurons

      @n1.neighbors = [@n2, @n3, @n4]
      @n2.neighbors = [@n1, @n3, @n4, @n5]
      @n3.neighbors = [@n1, @n2]
      @n4.neighbors = [@n1, @n2]
      @n5.neighbors = [@n2, @n6]
      @n6.neighbors = [@n5]
    end

    it 'neighbors' do
      @n1.neighbors.should eq Set.new([@n2, @n3, @n4])
      @n1.neighbors.to_a.should eq [@n2, @n3, @n4]
      @n4.neighbors.should eq Set.new([@n1, @n2])
    end

    it 'neighbors_by_radius' do
      {@n1 => {
         1 => [[@n2, @n3, @n4]],
         2 => [[@n2, @n3, @n4], [@n5]],
         3 => [[@n2, @n3, @n4], [@n5], [@n6]]},
       @n4 => {
          1 => [[@n1, @n2]],
          2 => [[@n1, @n2], [@n3, @n5]],
          3 => [[@n1, @n2], [@n3, @n5], [@n6]],
          4 => [[@n1, @n2], [@n3, @n5], [@n6]],
          100 => [[@n1, @n2], [@n3, @n5], [@n6]]}}.each do |neuron, hash|
        hash.each do |radius, neighbors|
          neurons.each { |n| n.reset_founded_status }
          neuron.neighbors_by_radius(radius).should eq neighbors
        end
      end
    end
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