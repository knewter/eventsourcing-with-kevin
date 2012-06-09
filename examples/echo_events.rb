require_relative '../lib/boot'
# Provide an example of events being shoved into the queue and being echoed by
# the EchoProcessor subscribed to the EventStore

echo_processor = EchoProcessor.new
store = EventStore::Array.new
store.add_subscriber(echo_processor)

event = Event.new('foo', {:payload => 'stuff'})

store.push(event)
