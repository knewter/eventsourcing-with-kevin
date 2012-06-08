require_relative '../../spec_helper'

describe EventStore do
  before do
    @store = EventStore.new
  end

  it "raises on #events" do
    lambda{ @store.events }.must_raise RuntimeError
  end

  it "raises on #events" do
    lambda{ @store.events_from }.must_raise RuntimeError
  end

  describe "subscribers" do
    before do
      @subscriber = MiniTest::Mock.new
    end

    it "publishes events to its subscribers" do
      event = {}
      @subscriber.expect(:handle, nil, [event])
      @store.add_subscriber(@subscriber)
      @store.publish(event)
      @subscriber.verify
    end
  end
end
