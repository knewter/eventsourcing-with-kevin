class DebitAccountHandler < AddEntryToAccountHandler
  
  def create_entry amount
    Debit.new(amount)
  end
  
end