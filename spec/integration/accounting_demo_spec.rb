require_relative '../spec_helper'

describe "Accounting demo" do
  before do
    @store = EventStore::Array.new
    @josh  = Account.new(name: 'Josh')
    @kevin = Account.new(name: 'Kevin')
    @event = Event.new('MoneyTransferEvent', {from: 'josh', to: 'kevin', amount: '500'})
    @money_processor = MoneyProcessor.new
  end
  
  it "creates event" do
  end
  
  it "adds event to event store" do
  end
  
  it "reads events and changes objects" do
  end

  
end
