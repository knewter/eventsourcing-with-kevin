class Processor
  attr_reader :last_event_position
  
  def process event
    raise "This is the abstract Process.  Override the process method in a given implementation."
  end
  
  
end
