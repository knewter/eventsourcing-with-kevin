class PostTransactionHandler
  
  def process event
    transaction = Transaction.new
    debits = event.payload[:debits]
    credits = event.payload[:credits]
    #seems like there should be a better way to do below
    debits.each do |debit|
      debit_entry = Debit.new(BigDecimal.new(debit[:amount]))
      prepare(debit_entry, debit[:account])
      transaction.add_entry(debit_entry)
    end
    credits.each do |credit|
      credit_entry = Credit.new(BigDecimal.new(credit[:amount]))
      prepare(credit_entry, credit[:account])
      transaction.add_entry(credit_entry)
    end
    transaction.post
  end
  
  private
  
  def prepare entry, account_number
    entry.account = Ledger.find_account(account_number)
  end
  
end