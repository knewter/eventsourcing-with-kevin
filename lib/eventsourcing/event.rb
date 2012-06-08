class Event
  attr_accessor :occurred_at, :recorded_at
  
  def initialize occurred_at=Time.now
    @occurred_at = occurred_at
  end
  
end
