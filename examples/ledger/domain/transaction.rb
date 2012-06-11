class Transaction
  include Calculations
  attr_accessor :entries, :occurred_at

  def initialize
    @entries = []
  end

  def balanced?
    balance == 0
  end

  def add_entry entry
    entry.transaction = self
    @entries << entry
  end

  def post
    entries.each{|entry| entry.account.add_entry(entry) } if balanced?
  end
end
