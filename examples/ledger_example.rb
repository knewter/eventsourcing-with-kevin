require 'bigdecimal'

require_relative '../lib/boot'
# Provide a slightly more real-world example, though still hugely contrived.
# Keep track of a ledger of accounts with events sent to the eventstore.

class Account
  def initialize number,name
    @number = number
    @name = name
    @subaccounts = []
    @entries = []
  end

  def number
    @number
  end

  def name
    @name
  end

  def balance
    entries.map(&:amount).inject(BigDecimal.new('0.00'), :+)
  end

  def formatted_balance
    balance.to_s('F')
  end

  def add_subaccount account
    @subaccounts << account
  end

  def add_entry entry
    @entries << entry
  end

  def entries
    @entries
  end
end

class Entry
  attr_accessor :amount

  def initialize amount
    @amount = amount
  end
end

class LedgerStore
  def initialize
    @accounts = {}
  end

  def accounts
    @accounts
  end

  def add_account number, name, parent
    new_account = Account.new(number,name)
    @accounts[number] = new_account
    if parent_account = find_account(parent)
      parent_account.add_subaccount(new_account)
    end
  end

  def find_account number
    @accounts[number]
  end
end

class CreateAccountHandler
  def process event
    Ledger.add_account event.payload[:number], event.payload[:name], event.payload[:parent]
  end
end

class AddEntryHandler
  def process event
    account_number = event.payload[:account]
    amount = BigDecimal.new(event.payload[:amount])
    account = Ledger.find_account(account_number)
    account.add_entry(Entry.new(amount))
  end
end

class ChartOfAccountsPrinter
  def self.print
    puts "#{Ledger.accounts.size} Accounts"
    puts "_____________________________________"
    sorted_account_keys = Ledger.accounts.keys.sort
    sorted_account_keys.each do |key|
      account = Ledger.find_account(key)
      puts "#{account.number} - #{account.name} - #{account.formatted_balance}"
    end
  end
end

# Initialize a ledger store
# FIXME: This definitely needs to be....better.
# A repository to find this in would be nice I'd think.
Ledger = LedgerStore.new

# Initialize all of the event handlers we'll be registering
create_account_handler = CreateAccountHandler.new
add_entry_handler = AddEntryHandler.new

# Initialize the CommandProcessor, and register the handlers
command_processor = CommandProcessor.new
command_processor.add_handler('CreateAccount', create_account_handler)
command_processor.add_handler('AddEntry', add_entry_handler)

# Create the eventstore
store = EventStore::Array.new
# Subscribe the commandprocessor to the eventstore
store.add_subscriber(command_processor)

events = []
events << Event.new('CreateAccount', {number: '1000', name: 'assets'})
events << Event.new('CreateAccount', {number: '2000', name: 'liabilities'})
events << Event.new('CreateAccount', {number: '3000', name: 'equity'})
events << Event.new('CreateAccount', {number: '4000', name: 'revenue'})
events << Event.new('CreateAccount', {number: '5000', name: 'expense'})
events << Event.new('CreateAccount', {number: '1100', name: 'cash', :parent => '1000'})
events << Event.new('CreateAccount', {number: '1200', name: 'receivables', :parent => '1000'})
events << Event.new('CreateAccount', {number: '2100', name: 'payables', :parent => '2000'})
events << Event.new('AddEntry', {account: '1100', amount: '100'})
events << Event.new('AddEntry', {account: '3000', amount: '-100'})

# Push some events into the eventstore
events.each do |event|
  store.push(event)
end

# Look at the chart of accounts
ChartOfAccountsPrinter.print
