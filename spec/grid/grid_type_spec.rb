require './lib/grid'
require './lib/grid/grid_type'
require './lib/grid/hexagonal'
require './lib/grid/square'

describe GridType do

  let(:data) { [0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11] }

  describe '' do
    [:square, :hexagonal].each do |type|
      let(:grid) { Grid.new({type: type, rows: 4, cols: 3}) }
      let(:matrix) { {0 => [0, 0], 1 => [0, 1], 2 => [0, 2], 3 => [0, 3], 4 => [1, 0], 5 => [1, 1],
                      6 => [1, 2], 7 => [1, 3], 8 => [2, 0], 9 => [2, 1], 10 => [2, 2], 11 => [2, 3]} }

      it "convert_to_index method with '#{type}' type" do
        matrix.each do |index, coordinate|
          grid.convert_to_index(coordinate).should eq index
        end
      end

      it "convert_to_coordinate" do
        matrix.each do |index, coordinate|
          grid.convert_to_coordinate(index).should eq coordinate
        end
      end
    end
  end

  describe "GridType::Square" do
    let(:grid) { Grid.new({type: :square, rows: 4, cols: 3}) }

    it "should return neighbors" do
      {0 => [1, 4], 1 => [0, 5, 2], 2 => [1, 6, 3], 3 => [2, 7], 4 => [0, 5, 8],
       5 => [1, 6, 9, 4], 6 => [2, 5, 10, 7], 7 => [3, 6, 11], 8 => [4, 9], 9 => [5, 8, 10],
       10 => [9, 6, 11], 11 => [7, 10], }.each do |index, neighbors|
        grid.neighbors(index).should =~ neighbors
      end
    end
  end

  describe "GridType::Hexagonal" do
    let(:grid) { Grid.new({type: :hexagonal, rows: 4, cols: 3}) }

    it "should return neighbors" do
      {0 => [1, 4, 5], 1 => [0, 5, 6, 2], 2 => [1, 3, 6, 7], 3 => [2, 7], 4 => [0, 5, 8],
       5 => [1, 6, 9, 0, 4, 8], 6 => [2, 7, 10, 1, 5, 9], 7 => [2, 3, 6, 10, 11],
       8 => [4, 5, 9], 9 => [8, 5, 6, 10], 10 => [9, 6, 7, 11], 11 => [10, 7]}.each do |index, neighbors|
        grid.neighbors(index).should =~ neighbors
      end
    end
  end
end