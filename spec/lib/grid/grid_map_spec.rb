require './spec/spec_helper'

describe GridMap do

  subject { Grid.new(:rows => 4, :cols => 3, :ceil_size => 15) }

  describe 'both' do
    let(:matrix) { {0 => [0, 0], 1 => [0, 1], 2 => [0, 2], 3 => [0, 3],
                    4 => [1, 0], 5 => [1, 1], 6 => [1, 2], 7 => [1, 3],
                    8 => [2, 0], 9 => [2, 1], 10 => [2, 2], 11 => [2, 3]} }

    it 'convert_to_coordinate(index)' do
      matrix.each do |index, coordinate|
        subject.send(:convert_to_coordinate, index).should eq coordinate
      end
    end

    it 'convert_to_index(coordinate)' do
      matrix.each do |index, coordinate|
        subject.send(:convert_to_index, coordinate).should eq index
      end
    end
  end

  describe "HexagonalGrid" do

    it 'width'
    it 'height'

    it 'polygon_points(col, row)'

    it "should return neighbors" do
      {0 => [1, 4, 5], 1 => [0, 5, 6, 2], 2 => [1, 3, 6, 7], 3 => [2, 7], 4 => [0, 5, 8],
       5 => [1, 6, 9, 0, 4, 8], 6 => [2, 7, 10, 1, 5, 9], 7 => [2, 3, 6, 10, 11],
       8 => [4, 5, 9], 9 => [8, 5, 6, 10], 10 => [9, 6, 7, 11], 11 => [10, 7]}.each do |index, neighbors|
        subject.neighbors(index).should =~ neighbors
      end
    end
  end
end