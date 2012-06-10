class Account
  include Calculations
  def initialize number, name
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
    if is_summary?
        subaccounts.map{|s| s.entries }.flatten
    else
      @entries
    end
  end

  def is_summary?
    subaccounts.any?
  end

  def formatted_balance
    balance.to_s('F')
  end

  def add_subaccount account
    @subaccounts << account
  end
end
