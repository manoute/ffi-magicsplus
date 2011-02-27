require 'spec_helper'


describe MagPlus::CoreExtensions::Integer do
  describe "#magics_set_name" do
    it "int should be used with seti" do
      80.magics_set_name.should == 'seti'
    end

  end
end
