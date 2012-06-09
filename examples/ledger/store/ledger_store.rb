class LedgerStore
  def initialize
    @accounts = {}
  end

  def accounts
    @accounts
  end

  def add_account number, name, parent
    new_account = Account.new(number,name)
    @accounts[number] = new_account
    if parent_account = find_account(parent)
      parent_account.add_subaccount(new_account)
    end
  end

  def find_account number
    @accounts[number]
  end
end
