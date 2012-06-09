class CreateAccountHandler
  def process event
    Ledger.add_account event.payload[:number], event.payload[:name], event.payload[:parent]
  end
end
