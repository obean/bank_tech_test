class Account
  attr_reader :balance

STATEMENT_HEADER = "date || credit || debit || balance"

  def initialize
    @balance = 0
  end

end