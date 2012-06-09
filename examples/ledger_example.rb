require 'bigdecimal'

require_relative '../lib/boot'
# Provide a slightly more real-world example, though still hugely contrived.
# Keep track of a ledger of accounts with events sent to the eventstore.

class Account
  def initialize number,name
    @number = number
    @name = name
    @balance = BigDecimal('0.0')
    @subaccounts = []
  end
  
  def number
    @number
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

  def add_subaccount account
    @subaccounts << account
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

class AddAccountHandler
  def process event
    Ledger.add_account event.payload[:number], event.payload[:name], event.payload[:parent]
  end
end

class ChartOfAccountsPrinter
  def self.print
    puts "#{Ledger.accounts.size} Accounts"
    puts "_____________________________________"
    sorted_account_keys = Ledger.accounts.keys.sort
    sorted_account_keys.each do |key|
      account = Ledger.find_account(key)
      puts "#{account.number} - #{account.name}"
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
add_account_handler = AddAccountHandler.new
command_processor = CommandProcessor.new
command_processor.add_handler('CreateAccount', add_account_handler)
accounts_list_processor = AccountsListProcessor.new
store = EventStore::Array.new
store.add_subscriber(command_processor)
store.add_subscriber(accounts_list_processor)

events = []
events << Event.new('CreateAccount', {number: '1000', name: 'assets'})
events << Event.new('CreateAccount', {number: '2000', name: 'liabilities'})
events << Event.new('CreateAccount', {number: '3000', name: 'equity'})
events << Event.new('CreateAccount', {number: '4000', name: 'revenue'})
events << Event.new('CreateAccount', {number: '5000', name: 'expense'})
events << Event.new('CreateAccount', {number: '1100', name: 'cash', :parent => '1000'})
events << Event.new('CreateAccount', {number: '1200', name: 'receivables', :parent => '1000'})
events << Event.new('CreateAccount', {number: '2100', name: 'payables', :parent => '2000'})

events.each do |event|
  store.push(event)
end

ChartOfAccountsPrinter.print
