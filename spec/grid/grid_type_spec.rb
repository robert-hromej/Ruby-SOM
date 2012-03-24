require './som/grid'
require './som/grid/grid_type'

describe GridType do

  let(:data) { [0, 1, 2, 3,
                4, 5, 6, 7,
                8, 9, 10, 11] }

  describe "GridType::Square" do

    let(:grid) { Grid.new({type: :square, rows: 4, cols: 3}) }

    it "convert_to_index method" do
      grid.convert_to_index([0, 0]).should eq 0
      grid.convert_to_index([1, 0]).should eq 4
      grid.convert_to_index([1, 1]).should eq 5
      grid.convert_to_index([1, 3]).should eq 7
      grid.convert_to_index([2, 0]).should eq 8
      grid.convert_to_index([2, 3]).should eq 11
    end

    it "convert_to_coordinate" do
      grid.convert_to_coordinate(0).should eq [0, 0]
      grid.convert_to_coordinate(1).should eq [0, 1]
      grid.convert_to_coordinate(2).should eq [0, 2]
      grid.convert_to_coordinate(3).should eq [0, 3]
      grid.convert_to_coordinate(4).should eq [1, 0]
      grid.convert_to_coordinate(5).should eq [1, 1]
      grid.convert_to_coordinate(6).should eq [1, 2]
      grid.convert_to_coordinate(7).should eq [1, 3]
      grid.convert_to_coordinate(8).should eq [2, 0]
      grid.convert_to_coordinate(9).should eq [2, 1]
      grid.convert_to_coordinate(10).should eq [2, 2]
      grid.convert_to_coordinate(11).should eq [2, 3]
    end

    it "should return neighbors" do
      grid.neighbors(data, 0).should =~ [1, 4]
      grid.neighbors(data, 1).should =~ [0, 5, 2]
      grid.neighbors(data, 3).should =~ [2, 7]
      grid.neighbors(data, 4).should =~ [0, 5, 8]
      grid.neighbors(data, 5).should =~ [1, 6, 9, 4]
      grid.neighbors(data, 7).should =~ [3, 6, 11]
      grid.neighbors(data, 8).should =~ [4, 9]
      grid.neighbors(data, 9).should =~ [5, 8, 10]
      grid.neighbors(data, 11).should =~ [7, 10]
    end

    it "should return neighbors with radius=2" do
      grid.find_neighbors(data, 0, 2).values.flatten.should =~ [1, 4, 2, 5, 8]
      grid.find_neighbors(data, 1, 2).values.flatten.should =~ [0, 5, 2, 3, 4, 6, 9]
      grid.find_neighbors(data, 3, 2).values.flatten.should =~ [2, 7, 1, 6, 11]
      grid.find_neighbors(data, 4, 2).values.flatten.should =~ [0, 5, 8, 1, 6, 9]
      grid.find_neighbors(data, 5, 2).values.flatten.should =~ [1, 6, 9, 4, 0, 2, 7, 8, 10]
      grid.find_neighbors(data, 7, 2).values.flatten.should =~ [3, 6, 11, 2, 5, 10]
      grid.find_neighbors(data, 8, 2).values.flatten.should =~ [4, 9, 0, 5, 10]
      grid.find_neighbors(data, 9, 2).values.flatten.should =~ [5, 8, 10, 1, 4, 6, 11]
      grid.find_neighbors(data, 11, 2).values.flatten.should =~ [7, 10, 3, 6, 9]
    end
  end

  describe "GridType::Line" do
    let(:grid) { Grid.new({type: :line, rows: 4, cols: 3}) }

    it "should return neighbors with radius=1" do
      grid.neighbors(data, 0, 1).should =~ [1]
      grid.neighbors(data, 5, 1).should =~ [4, 6]
      grid.neighbors(data, 11, 1).should =~ [10]
    end
  end

end