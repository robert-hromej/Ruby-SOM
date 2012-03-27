require './lib/grid'

describe Grid do

  let(:attributes) { {type: :square, rows: 3, cols: 4} }

  subject { Grid.new attributes }

  it "should be correct variables" do
    subject.type.should eq :square
    subject.rows.should eq 3
    subject.cols.should eq 4
  end

  it "neighbors method" do
    #subject.
    pending
  end

end