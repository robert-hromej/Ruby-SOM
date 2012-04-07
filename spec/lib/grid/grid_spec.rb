require './spec/spec_helper'

describe Grid do

  subject { Grid.new(:rows => 3, :cols => 4, :ceil_size => 15) }

  it "should be correct variables" do
    subject.rows.should eq 3
    subject.cols.should eq 4
    subject.ceil_size.should eq 15
    subject.size.should eq 12
  end

  it "neighbors method" do
    #subject.
    pending
  end
end