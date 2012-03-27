require './lib/graph'

describe Graph do

  subject { Graph.new }

  it 'add_relation' do
    subject.add_relation [1, 2]
    subject.relations.should eq [[1, 2].to_set].to_set
    subject.add_relation [2, 1]
    subject.relations.should eq [[1, 2].to_set].to_set
    subject.add_relation [1, 3]
    subject.relations.should eq [[1, 2].to_set, [1, 3].to_set].to_set
  end

  it 'sorted relation' do
    subject.add_relation [3, 2]
    subject.add_relation [1, 4]
    subject.add_relation [3, 1]
    subject.relations.should eq [[1, 3].to_set, [1, 4].to_set, [2, 3].to_set].to_set
  end

  it 'uniq' do
    subject.relations = [[1, 2].to_set].to_set
    subject.relations.size.should eq 1
    subject.add_relation [1, 2]
    subject.add_relation [2, 1]
    subject.relations.should eq [[1, 2].to_set].to_set
    subject.relations.size.should eq 1
  end

  it 'remove relation' do
    subject.relations = [[1, 3].to_set, [1, 4].to_set, [2, 3].to_set].to_set

    subject.remove_relation [1, 3]
    subject.relations.should eq [[1, 4].to_set, [2, 3].to_set].to_set

    subject.remove_relation [4, 1]
    subject.relations.should eq [[2, 3].to_set].to_set

    subject.remove_relation [1, 1]
    subject.relations.should eq [[2, 3].to_set].to_set
  end

  it 'neighbors' do
    subject.relations = [[1, 2].to_set, [1, 3].to_set, [1, 4].to_set,
                         [2, 5].to_set, [2, 3].to_set, [2, 4].to_set].to_set

    subject.neighbors_by_key(1).should == [2, 3, 4]
    subject.neighbors_by_key(2).should == [1, 3, 4, 5]
    subject.neighbors_by_key(3).should == [1, 2]
    subject.neighbors_by_key(4).should == [1, 2]
    subject.neighbors_by_key(5).should == [2]

  end

  context 'neighbors_by_radius' do

    before(:each) do
      subject.relations = [[1, 2], [1, 3], [1, 4], [2, 5], [2, 3], [2, 4], [5, 6]].map{|x| x.to_set}.to_set
    end

    it 'radius = 1' do
      neighbors = subject.neighbors_by_radius(1, 1)
      neighbors.should == {1 => [2, 3, 4]}

      neighbors = subject.neighbors_by_radius(6, 1)
      neighbors.should == {6 => [5]}
    end

    it 'radius = 2' do
      neighbors = subject.neighbors_by_radius(1, 2)
      neighbors.should == {1 => {
        2 => [5],
        3 => [],
        4 => []}}

      neighbors = subject.neighbors_by_radius(6, 2)
      neighbors.should == {6 => {
        5 => [2]}}
    end

    it 'radius = 3' do
      neighbors = subject.neighbors_by_radius(1, 3)
      neighbors.should == {1 => {
        2 => {
          5 => [6]},
        3 => {},
        4 => {}}}

      neighbors = subject.neighbors_by_radius(6, 3)
      neighbors.should == {6 => {
        5 => {
          2 => [1, 3, 4]}}}
    end


    it 'radius = 4' do
      neighbors = subject.neighbors_by_radius(6, 4)
      neighbors.should == {6 => {
        5 => {
          2 => {
            1 => [],
            3 => [],
            4 => []}}}}

    end

    it 'radius = 100' do
      neighbors = subject.neighbors_by_radius(1, 100)
      neighbors.should == {1 => {
        2 => {
          5 => {
            6 => {}}},
        3 => {},
        4 => {}}}

      neighbors = subject.neighbors_by_radius(6, 100)
      neighbors.should == {6 => {
        5 => {
          2 => {
            1 => {},
            3 => {},
            4 => {}}}}}
    end
  end

  context 'neighbors_by_level' do
    before(:each) do
      subject.relations = [[1, 2], [1, 3], [1, 4], [2, 5], [2, 3], [2, 4], [5, 6]]
    end

    it 'level = 1' do
      neighbors = subject.neighbors_by_level(1, 1)
      neighbors.should == [[1], [2, 3, 4]]

      neighbors = subject.neighbors_by_level(4, 1)
      neighbors.should == [[4], [1, 2]]
    end

    it 'level = 2' do
      neighbors = subject.neighbors_by_level(1, 2)
      neighbors.should == [[1], [2, 3, 4], [5]]

      neighbors = subject.neighbors_by_level(4, 2)
      neighbors.should == [[4], [1, 2], [3, 5]]
    end

    it 'level = 3' do
      neighbors = subject.neighbors_by_level(1, 3)
      neighbors.should == [[1], [2, 3, 4], [5], [6]]

      neighbors = subject.neighbors_by_level(4, 3)
      neighbors.should == [[4], [1, 2], [3, 5], [6]]
    end

    it 'level = 100' do
      neighbors = subject.neighbors_by_level(4, 100)
      neighbors.should == [[4], [1, 2], [3, 5], [6]]
    end
  end
end
