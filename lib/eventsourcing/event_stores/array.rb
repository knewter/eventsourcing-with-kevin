require_relative '../event_store.rb'

class EventStore::Array < EventStore

  def initialize
    @events = []
  end

  def events start=0
    @events[start..-1]
  end
end
