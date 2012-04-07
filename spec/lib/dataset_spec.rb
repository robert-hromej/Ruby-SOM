require './spec/spec_helper'

describe Dataset do
  subject { Dataset.new './spec/datasets/eight_color.csv' }

  it "should be correct variables" do
    subject.file_path.should eq './spec/datasets/eight_color.csv'
  end

  it 'should size' do
    subject.size.should eq 8
  end

  it 'fields' do
    subject.fields.should eq ['R', 'G', 'B']
  end

  it 'data' do
    subject.data.should eq [[0, 0, 0],
                            [255, 0, 0],
                            [0, 255, 0],
                            [0, 0, 255],
                            [255, 255, 0],
                            [0, 255, 255],
                            [255, 0, 255],
                            [255, 255, 255]]
  end

  it 'normalized_data' do
    subject.normalized_data.should eq [[0, 0, 0],
                                       [1, 0, 0],
                                       [0, 1, 0],
                                       [0, 0, 1],
                                       [1, 1, 0],
                                       [0, 1, 1],
                                       [1, 0, 1],
                                       [1, 1, 1]]
  end
end