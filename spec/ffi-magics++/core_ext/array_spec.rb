require 'spec_helper'


describe MagPlus::CoreExtensions::Array do
  describe "#magics_set_name" do
    it "1D array of int should be used with set1i" do
      [1,2,3].magics_set_name.should == 'set1i'
    end

    it "1D array of string should be used with set1c" do
      %w{toto lulu}.magics_set_name.should == 'set1c'
    end

    it "1D array of float should be used with set1r" do
      [1.0, 2.0 ,3.0].magics_set_name.should == 'set1r'
    end

    it "2D array of int should be used with set2i" do
      [[1,2,3],[1,2,3]].magics_set_name.should == 'set2i'
    end

    it "2D array of float should be used with set2r" do
      [[1.0, 2.0 ,3.0],[1.0, 2.0 ,3.0]].magics_set_name.should == 'set2r'
    end

    it "Other type of array should raise an exception" do
      lambda { [Object.new].magics_set_name }.should raise_error(
        TypeError )
    end

  end
end
