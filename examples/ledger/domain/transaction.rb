class Transaction
  attr_accessor :debits, :credits

  def initialize
    @debits = []
    @credits = []
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

  def sum_of debits_or_credits
    debits_or_credits.map(&:amount).inject(BigDecimal.new('0.00'), :+)
  end

  def add_debit debit
    debit.transaction = self
    @debits << debit
  end

  def add_credit credit
    credit.transaction = self
    @credits << credit
  end

  def entries
    debits.concat(credits)
  end

  def post
    entries.each{|entry| entry.account.add_entry(entry) } if balanced?
  end
end
