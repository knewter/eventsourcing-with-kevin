require_relative '../../spec_helper'

describe Processor do
  before do
    @processor = Processor.new
  end

  it "raises on #process" do
    lambda{ @processor.process({}) }.must_raise RuntimeError
  end
end
