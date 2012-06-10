class CreditAccountHandler < AddEntryToAccountHandler
  
  def create_entry amount
    Credit.new(amount)
  end
  
end
