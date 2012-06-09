require 'bigdecimal'

require_relative '../lib/boot'
# Provide a slightly more real-world example, though still hugely contrived.
# Keep track of a ledger of accounts with events sent to the eventstore.

class Account
  def initialize name
    @name = name
    @balance = BigDecimal('0.0')
  end

  def name
    @name
  end

  def debit(amount)
    @balance -= amount
  end

  def credit(amount)
    @balance += amount
  end

  def balance
    @balance
  end
  
  def to_s
    name.to_s
  end
end

class LedgerStore
  def initialize
    @accounts = {}
  end

  def add_account name
    account = Account.new(name)
    @accounts[name] = account
    puts 'created account'
  end
  
  def find_account name
    @accounts[name]
  end

  def each &block
    @accounts.values.each do |account|
      block.call(account)
    end
  end
end

class CommandProcessor < Processor
  def process event
    case event.type
    when 'CreateAccount'
      Ledger.add_account event.payload[:name]
    else
      raise "WTF is this crap?"
    end
  end
end

Ledger = LedgerStore.new
command_processor = CommandProcessor.new
store = EventStore::Array.new
store.add_subscriber(command_processor)

events = []
events << Event.new('CreateAccount', {name: 'bank'})
events << Event.new('CreateAccount', {name: 'kevin'})
events << Event.new('CreateAccount', {name: 'josh'})

events.each do |event|
  store.push(event)
end

bank_account = Ledger.find_account 'bank'
puts bank_account
