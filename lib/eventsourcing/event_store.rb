class EventStore
  def push(event)
    # Push the event on the stack
    events << event
    # Process it
    event.process
    # Return it
    event
  end

  def events
    raise "This is the abstract EventStore.  Override the event storage method in a given implementation."
  end
end
