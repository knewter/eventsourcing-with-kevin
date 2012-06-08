require 'celluloid'

class EventStore
  include Celluloid

  def initialize
    @events = []
  end

  def push(event)
    @events << event
    event
  end
end
