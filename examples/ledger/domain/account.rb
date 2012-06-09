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

  def balance
    entries.map(&:amount).inject(BigDecimal.new('0.00'), :+)
  end

  def formatted_balance
    balance.to_s('F')
  end

  def add_subaccount account
    @subaccounts << account
  end

  def add_entry entry
    @entries << entry
  end

  def entries
    @entries
  end
end
