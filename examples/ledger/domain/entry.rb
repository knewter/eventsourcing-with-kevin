class Entry
  attr_accessor :amount, :transaction, :account, :occurred_at

  def initialize amount
    @amount = amount
  end
end
