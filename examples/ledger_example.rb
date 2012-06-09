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
  
  def accounts 
    @accounts
  end

  def add_account name
    account = Account.new(name)
    @accounts[name] = account
  end
  
  def find_account name
    @accounts[name]
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

class ChartOfAccountsPrinter
  def self.print
    puts "#{Ledger.accounts.size} Accounts"
    puts "_____________________________________"
    Ledger.accounts.each_pair do |name, account|
      puts account
    end
  end
end

class AccountsListProcessor < Processor
  def process event
    # I don't care about the event, I'm going to publish the event and then the
    # state of all the accounts after that event.
    puts "---------------------------"
    puts "New event received: #{event.inspect}"
    puts "---------------------------"
    puts ""
  end
end

Ledger = LedgerStore.new
command_processor = CommandProcessor.new
accounts_list_processor = AccountsListProcessor.new
store = EventStore::Array.new
store.add_subscriber(command_processor)
store.add_subscriber(accounts_list_processor)

events = []
events << Event.new('CreateAccount', {name: 'assets'})
events << Event.new('CreateAccount', {name: 'liabilities'})
events << Event.new('CreateAccount', {name: 'equity'})
events << Event.new('CreateAccount', {name: 'revenue'})
events << Event.new('CreateAccount', {name: 'expense  '})

events.each do |event|
  store.push(event)
end

ChartOfAccountsPrinter.print
