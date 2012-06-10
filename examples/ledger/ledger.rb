require 'bigdecimal'

require_relative '../../lib/boot'

include EventSourcing

require_relative './domain/account'
require_relative './domain/entry'
require_relative './domain/debit'
require_relative './domain/credit'
require_relative './domain/transaction'
require_relative './store/ledger_store'
require_relative './handlers/add_entry_to_account_handler'
require_relative './handlers/create_account_handler'
require_relative './handlers/debit_account_handler'
require_relative './handlers/credit_account_handler'
require_relative './handlers/post_transaction_handler'
require_relative './reports/chart_of_accounts_printer'

# Provide a slightly more real-world example, though still hugely contrived.
# Keep track of a ledger of accounts with events sent to the eventstore.

# Initialize a ledger store
# FIXME: This definitely needs to be....better.
# A repository to find this in would be nice I'd think.
Ledger = LedgerStore.new

# Initialize all of the event handlers we'll be registering
create_account_handler = CreateAccountHandler.new
debit_account_handler = DebitAccountHandler.new
credit_account_handler = CreditAccountHandler.new
post_transaction_handler = PostTransactionHandler.new
 
# Initialize the CommandProcessor, and register the handlers
command_processor = CommandProcessor.new
command_processor.add_handler('CreateAccount', create_account_handler)
command_processor.add_handler('DebitAccount', debit_account_handler)
command_processor.add_handler('CreditAccount', credit_account_handler)
command_processor.add_handler('PostTransaction', post_transaction_handler)

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
events << Event.new('DebitAccount', {account: '1100', amount: '100'})
events << Event.new('CreditAccount', {account: '3000', amount: '100'})
accounts = ['1100','1200','2100']
r1 = Random.new
100000.times do 
  account1 = accounts[r1.rand(0...2)]
  account2 = accounts[r1.rand(0...2)]  
  amount = r1.rand(10...5000).to_s
  events << Event.new('PostTransaction', {debits: [{account: account1, amount: amount}], credits: [{account: account2, amount: amount}]})
end

# Push some events into the eventstore
events.each do |event|
  store.push(event)
end

# Look at the chart of accounts
ChartOfAccountsPrinter.print
