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
