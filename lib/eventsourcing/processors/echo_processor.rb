class EchoProcessor < Processor
  def process event
    puts "Event received: " + event.inspect
  end
end
