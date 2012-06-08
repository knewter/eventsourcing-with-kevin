require_relative '../../spec_helper'

describe EventStore do
  before do
    @store = EventStore.new
  end

  it "raises on #events" do
    lambda{ @store.events }.must_raise RuntimeError
  end
<<<<<<< HEAD
  
  it "raises on #events_from" do
=======

  it "raises on #events" do
>>>>>>> b239d82f1f00a754746ae9ee5eb8024763dccd5f
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
