# This is the main lib file.
require_relative './eventsourcing/event_store'
require_relative './eventsourcing/event_stores/array'
require_relative './eventsourcing/event'
require_relative './eventsourcing/processor'
require_relative './eventsourcing/processors/command_processor'
