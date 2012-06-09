require_relative '../../../spec_helper'

describe CommandProcessor do
  before do
    @processor = CommandProcessor.new
  end

  it "can add handlers" do
    handler = MiniTest::Mock.new
    @processor.add_handler('some_event_type', handler)
    @processor.send(:handler_for, 'some_event_type').must_equal handler
  end
end
