require_relative '../../spec_helper'

describe EventStore do
  before do
    @store = EventStore.new
  end

  it "adds an event to the list" do
    new_event = {}
    @store.push(new_event).must_equal new_event
  end
end
