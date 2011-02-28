require 'spec_helper'
require 'fileutils'

ENV["MAGPLUS_QUIET"] = "yes"

describe MagPlus do
  before do
    @grib_file = File.join(File.dirname(__FILE__),"../data","z500.grb")
    @output_file = File.join(File.dirname(__FILE__),"../data","sample.ps")
    @output_file1 = File.join(File.dirname(__FILE__),"../data","sample1.ps")
    @grib_visu = File.join(File.dirname(__FILE__),"../data","z500.ps")
    @array2D_visu = File.join(File.dirname(__FILE__),"../data","2D.ps")
    @symb_visu = File.join(File.dirname(__FILE__),"../data","symb.ps")
  end

  def ps_files_compare(expected_output)
    output = open(@output_file,"r") {|f| f.readlines} 
    expected = open(expected_output,"r") {|f| f.readlines} 
    (output - expected).length.should be <= 1 #only date may be different
  end

  context "return value from function" do
    it "function starting with mag_ should exists" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.coast #crash without this line in 1.9
        c.respond_to?(:mag_coast).should be_true
      end
    end

    it "function starting with mag_ should return her original API value (always nil)" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.mag_coast.should be_nil
      end
    end

    it "equivalent function not starting with mag_ should return self" do
      MagPlus.open 
      MagPlus.plot_basic(@output_file)
      MagPlus.coast.respond_to?(:plot).should be_true
      MagPlus.close
    end

    it "except for method that already exists and new" do
      MagPlus.respond_to?(:new).should be_false
    end
    
    it "mag_new equivalent returning self are new_page, new_subpage, new_super_page" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.new_page.should.respond_to?(:mag_plot)
        c.coast
      end
    end
  end

  context "array not valid" do
    it "set1r sould raise an exception" do
      MagPlus.open 
      expect {
        MagPlus.set1r("contour_level_list",Object.new)
      }.to raise_error(TypeError)
      MagPlus.coast
      MagPlus.close
    end

    it "set1i sould raise an exception" do
      MagPlus.open 
      expect {
        MagPlus.set1i("symbol_input_marker_list",Object.new)
      }.to raise_error(TypeError)
      MagPlus.coast
      MagPlus.close
    end

    it "set2r sould raise an exception" do
      MagPlus.open 
      expect {
        MagPlus.set2r("toto",Object.new)
      }.to raise_error(TypeError)
      MagPlus.coast
      MagPlus.close
    end
  end

  if narray_installed
    context "NArray" do
      it "set1r should work with narray" do
        MagPlus.open do |c|
          c.plot_basic(@output_file)
          c.plot_grib(@grib_file) do
            c.set1r("contour_level_list",NArray.float(40).indgen!(530,1))
          end
        end
        ps_files_compare(@grib_visu)
      end

      it "set2r should work with narray" do
        MagPlus.open do |c|
          c.plot_basic(@output_file)
          c.plot2D do
            data=NArray.float(360,181).indgen!
            (0..359).each do |x|
              (0..180).each {|y| data[x,y] = x}
            end
            c.set2r('input_field', data)
          end

        end
        ps_files_compare(@array2D_visu)
      end

      it "set1i should work with narray" do
        MagPlus.open do |c|
          c.plot_basic(@output_file)
          c.setc("symbol_type","marker")
          c.set1r("symbol_input_x_position",NArray.float(4).indgen!(1.0,1))
          c.set1r("symbol_input_y_position",NArray[44.0, 51.0,52.0,53.0])
          c.set1i("symbol_input_marker_list",NArray.int(4).fill(3))
          c.setr("symbol_height",1.0)
          c.symb
          c.coast
        end
        ps_files_compare(@symb_visu)
      end
    end
  end

  context "Ruby Array" do
    it "set1r should work with ruby array" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.plot_grib(@grib_file) do
          c.set1r("contour_level_list",
            (530..569).inject([]) {|a,e| a << e })
        end
      end
      ps_files_compare(@grib_visu)
    end

    it "set2r should work with ruby array" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.plot2D do
          data = []
          (0..180).each {|i| data << (360.times.inject([]){|r,e| r << e})}
          c.set2r('input_field', data)
        end

      end
      ps_files_compare(@array2D_visu)
    end

    it "set1i should work with ruby array" do
      MagPlus.open do |c|
        c.plot_basic(@output_file)
        c.setc("symbol_type","marker")
        c.set1r("symbol_input_x_position",[1.0, 2.0, 3.0,4.0])
        c.set1r("symbol_input_y_position",[44.0, 51.0,52.0,53.0])
        c.set1i("symbol_input_marker_list",[3,3,3,3])
        c.setr("symbol_height",1.0)
        c.symb
        c.coast
      end
      ps_files_compare(@symb_visu)
    end
  end

  context "More object oriented" do
    before do
      MagPlus.open do |m|
        m.setc("output_fullname",@output_file1)
        m.setc("output_format","ps")
        %w{subpage_lower_left_latitude subpage_lower_left_longitude
        subpage_upper_right_latitude subpage_upper_right_longitude}.each do |str|
          m.reset(str)
        end
        m.setr('subpage_upper_right_latitude',30.0)
        m.coast
        %w{subpage_lower_left_latitude subpage_lower_left_longitude
        subpage_upper_right_latitude subpage_upper_right_longitude}.each do |str|
          m.reset(str)
        end
      end
    end

    after do
      File.delete @output_file1
      File.delete @output_file
    end

    it "coast(and others...) should accept a hash" do
      MagPlus.open do |m|
        m.setc("output_fullname",@output_file)
        m.setc("output_format","ps")
        m.coast({:subpage_upper_right_latitude => 30.0})
      end
      ps_files_compare(@output_file1)
    end

    it "param = foo should act like set..('param',foo)" do
      MagPlus.open do |m|
        m.setc("output_fullname",@output_file)
        m.setc("output_format","ps")
        m.subpage_upper_right_latitude = 30.0
        m.coast 
      end
      ps_files_compare(@output_file1)
    end

    it "coast(and others...) should accept a block" do
      MagPlus.open do |m|
        m.setc("output_fullname",@output_file)
        m.setc("output_format","ps")
        m.coast do |c|
          c.subpage_upper_right_latitude = 30.0
        end
      end
      ps_files_compare(@output_file1)
    end
    

  end
end

