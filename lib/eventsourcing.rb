# This is the main lib file.
require_relative './eventsourcing/event_store'

# Initialize an event store so other things can use it
event_store = EventStore.new
