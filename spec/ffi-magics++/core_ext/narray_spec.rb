require 'spec_helper'

if narray_installed
  describe MagPlus::CoreExtensions::NArray do
    describe "#magics_set_name" do
      it "1D narray of int should be used with set1i" do
        NArray.int(3).indgen.magics_set_name.should == 'set1i'
      end

      it "1D narray of string should be used with set1c" do
        NArray['toto','lulu'].magics_set_name.should == 'set1c'
      end

      it "1D narray of float should be used with set1r" do
        NArray.float(3).indgen.magics_set_name.should == 'set1r'
      end

      it "2D narray of int should be used with set2i" do
        NArray.int(3,3).indgen.magics_set_name.should == 'set2i'
      end

      it "2D narray of float should be used with set2r" do
        NArray.float(3,3).indgen.magics_set_name.should == 'set2r'
      end

      it "Other type of narray should raise an exception" do
        lambda { [Object.new].magics_set_name }.should raise_error(
          TypeError )
      end

    end
  end
end
