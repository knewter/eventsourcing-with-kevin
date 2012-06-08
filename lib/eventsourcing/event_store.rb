require 'celluloid'

class EventStore
  include Celluloid

  def push(event)
    events << event
    return event
  end

  def events
    raise "This is the abstract EventStore.  Override the event storage method in a given implementation."
  end
end
