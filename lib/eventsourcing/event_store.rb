class EventStore
  def initialize
    @events = []
  end

  def push(event)
    @events << event
  end
end
