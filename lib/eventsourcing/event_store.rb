require 'celluloid'

class EventStore
  def push(event)
    events << event
    event
  end

  def events
    raise "This is the abstract EventStore.  Override the event storage method in a given implementation."
  end
end
