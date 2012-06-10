class Account
  def initialize number,name
    @number = number
    @name = name
    @subaccounts = []
    @entries = []
  end

  def number
    @number
  end

  def name
    @name
  end

  def subaccounts
    @subaccounts
  end

#should this lead to creating SummaryAccount(has subaccounts) and DetailAccount(does not have subaccounts)
#Assets would be an example SummaryAccount
#SummaryAccount entries are a collection of subaccount entries so you can't post to SummaryAccount 

  def add_entry entry
    @entries << entry
  end

  def entries
    @entries
  end
  
  def debits
    entries.select{|entry| entry.is_a? Debit}
  end
  
  def credits
    entries.select{|entry| entry.is_a? Credit}
  end
  
  def sum_of debits_or_credits
    debits_or_credits.map(&:amount).inject(BigDecimal.new('0.00'), :+)
  end
  
  def balance
    sum_of(debits) - sum_of(credits)
  end

  def formatted_balance
    balance.to_s('F')
  end

  def add_subaccount account
    @subaccounts << account
  end
end
