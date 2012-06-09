class CommandProcessor < Processor
  def initialize
    super
    @handlers = {}
  end

  def add_handler(event_type, handler)
    @handlers[event_type] = handler
  end

  def process event
    log("No handler found for #{event.type}") unless handler_for(event.type)
    case event.type
    when 'CreateAccount'
      Ledger.add_account event.payload[:name]
    else
      raise "WTF is this crap?"
    end
  end

  private

  def handler_for(event_type)
    @handlers[event_type]
  end

  def log message
    STDOUT.puts message
  end
end
