require_relative '../event_store.rb'

class EventStore::Array < EventStore

  def initialize
    @events = []
  end

  def events
    @events
  end
end
