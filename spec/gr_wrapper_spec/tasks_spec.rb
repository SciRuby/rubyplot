require 'spec_helper'

describe Rubyplot::GRWrapper::Tasks do
  include Rubyplot::GRWrapper::Tasks
  
  context BeginPrint, focus: true do
    it "creates a beginprint task" do
      t = BeginPrint.new "new_file.bmp"

      expect(t.file_name).to eq("new_file.bmp")
      expect(t.call).to eq(true)
    end
  end
end
