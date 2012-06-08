require_relative '../../spec_helper'

describe EventStore do
  before do
    @store = EventStore.new
  end

  it "raises on #events" do
    lambda{ @store.events }.must_raise
  end
end
