class AddEntryHandler
  def process event
    account_number = event.payload[:account]
    amount = BigDecimal.new(event.payload[:amount])
    account = Ledger.find_account(account_number)
    account.add_entry(Entry.new(amount))
  end
end
