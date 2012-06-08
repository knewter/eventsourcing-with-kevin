class EventStore
  def initialize
    @subscribers = []
  end

  def push event
    # Push the event on the stack
    events << event
    # Return it
    event
  end

  def add_subscriber subscriber
    @subscribers << subscriber
  end

  def publish event
    @subscribers.each do |subscriber|
      subscriber.handle(event)
    end
  end

  def events
    raise "This is the abstract EventStore.  Override the event storage method in a given implementation."
  end

  def events_from start=nil
    raise "This is the abstract EventStore.  Override the events_from method in a given implementation."
  end
end
