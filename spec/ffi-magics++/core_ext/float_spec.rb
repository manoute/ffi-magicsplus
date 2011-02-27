require 'spec_helper'


describe MagPlus::CoreExtensions::Float do
  describe "#magics_set_name" do
    it "float should be used with setr" do
      (80.0).magics_set_name.should == 'setr'
    end

  end
end
