require 'bigdecimal'

require_relative '../../lib/boot'
require_relative './domain/account'
require_relative './domain/entry'
require_relative './store/ledger_store'
require_relative './handlers/create_account_handler'
require_relative './handlers/add_entry_handler'

# Provide a slightly more real-world example, though still hugely contrived.
# Keep track of a ledger of accounts with events sent to the eventstore.

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
