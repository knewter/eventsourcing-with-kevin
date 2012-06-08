require_relative '../spec_helper'

describe "Accounting demo" do
  before do
    @store = EventStore::Array.new
    @josh  = Account.new(name: 'Josh')
    @kevin = Account.new(name: 'Kevin')
    @event = Event.new('MoneyTransferEvent', {from: 'josh', to: 'kevin', amount: '500'})
  end

  it "publishes events to accounts" do
    @store.push(@event)
    @josh.seen_events.must_include(@event)
    @kevin.seen_events.must_include(@event)
  end
end
