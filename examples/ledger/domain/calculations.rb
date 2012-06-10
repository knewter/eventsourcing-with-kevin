module Calculations
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
end