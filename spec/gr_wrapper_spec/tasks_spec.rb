require 'gr_wrapper'
require 'spec_helper'


describe Rubyplot::GRWrapper::Tasks do
  include Rubyplot::GRWrapper::Tasks
  
  context Rubyplot::GRWrapper::Tasks::BeginPrint do
    it "creates a beginprint task" do
      t = Rubyplot::GRWrapper::Tasks::BeginPrint.new "new_file.bmp"

      expect(t.file_name).to eq("new_file.bmp")
      expect(t.call).to eq(true)
    end
  end
end
