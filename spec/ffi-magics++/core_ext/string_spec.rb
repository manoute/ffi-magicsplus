require 'spec_helper'


describe MagPlus::CoreExtensions::String do
  describe "#magics_set_name" do
    it "string should be used with setc" do
      "totoro".magics_set_name.should == 'setc'
    end

  end
end
