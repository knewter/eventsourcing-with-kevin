class Event
  attr_accessor :recorded_at
  attr_reader   :occurred_at, :payload, :type

  def initialize type, occurred_at=Time.now, payload={}
    @type = type
    @occurred_at = occurred_at
    @payload = payload
  end
end
