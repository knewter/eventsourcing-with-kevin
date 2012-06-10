class Transaction
  attr_accessor :entries

  def initialize
    @entries = []
  end

  def balanced?
    balance == 0
  end

  def balance
    sum_debits - sum_credits
  end

  def sum_debits
    sum_of(debits)
  end

  def sum_credits
    sum_of(credits)
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

  def add_entry entry
    entry.transaction = self
    @entries << entry
  end

  def post
    entries.each{|entry| entry.account.add_entry(entry) } if balanced?
  end
end
