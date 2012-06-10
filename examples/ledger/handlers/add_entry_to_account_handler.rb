class AddEntryToAccountHandler
  
  def process event
    account_number = event.payload[:account]
    amount = BigDecimal.new(event.payload[:amount])
    account = Ledger.find_account(account_number)
    account.add_entry(create_entry(amount))
  end
  
  def create_entry amount
  end
  
end