require_relative '../../../spec_helper'

describe EventStore::Array do
  before do
    @store = EventStore::Array.new
    @mock_event = MiniTest::Mock.new
    @mock_event2 = MiniTest::Mock.new
    @mock_event.expect(:process, nil)
  end

  it "adds an event to the list" do
    @store.push(@mock_event).must_equal @mock_event
  end

  it "calls #process on events passed in" do
    @store.push(@mock_event)
    assert @mock_event.verify
  end
  
  it "returns events from starting point" do
    @store.push(@mock_event)
    @store.push(@mock_event2)
    @store.events() = [@mock_event,@mock_event2]
    @store.events(1) = [@mock_event2]
  end
  
end
