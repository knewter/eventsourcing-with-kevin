require_relative '../event_store.rb'

class EventStore::Array < EventStore
  def initialize
    super
    @events = []
  end

  def events
    @events
  end

  def events_from start=0
    @events[start..-1]
  end
end
