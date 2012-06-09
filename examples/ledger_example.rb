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
end

class AccountStore
  def initialize
    @accounts = {}
  end

  def add account
    @accounts[account.name] = account
  end

  def find name
    @accounts[name]
  end

  def each &block
    @accounts.values.each do |account|
      block.call(account)
    end
  end
end

josh  = Account.new('josh')
kevin = Account.new('kevin')
bank  = Account.new('bank')

Accounts = AccountStore.new
Accounts.add josh
Accounts.add kevin
Accounts.add bank

class CommandProcessor < Processor
  def process event
    case event.type
    when 'TransferFunds'
      from_account = Accounts.find(event.payload[:from])
      to_account = Accounts.find(event.payload[:to])
      amount = event.payload[:amount]
      from_account.debit(amount)
      to_account.credit(amount)
    else
      raise "WTF is this crap?"
    end
  end
end

class AccountsListPrinter
  def self.print
    Accounts.each do |account|
      puts "#{account.name} - balance: #{account.balance.to_s("F")}"
    end
  end
end

class AccountsListProcessor < Processor
  def process event
    # I don't care about the event, I'm going to publish the event and then the
    # state of all the accounts after that event.
    puts "---------------------------"
    puts "New event received: #{event.inspect}"
    puts "Accounts after this event:"
    AccountsListPrinter.print
    puts "---------------------------"
    puts ""
  end
end

command_processor = CommandProcessor.new
accounts_list_processor = AccountsListProcessor.new
store = EventStore::Array.new
store.add_subscriber(command_processor)
store.add_subscriber(accounts_list_processor)

events = []
events << Event.new('TransferFunds', {from: 'bank', to: 'josh', amount: BigDecimal('100.0')})
events << Event.new('TransferFunds', {from: 'bank', to: 'kevin', amount: BigDecimal('50.0')})
events << Event.new('TransferFunds', {from: 'josh', to: 'kevin', amount: BigDecimal('22.0')})

events.each do |event|
  store.push(event)
end
