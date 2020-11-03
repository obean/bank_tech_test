

class Transaction
  attr_reader :date, :deposit_amount, :withdrawal_amount, :balance

  def initialize(date, deposit_amount, withdrawal_amount, balance)
    @date = date
    @deposit_amount = deposit_amount
    @withdrawal_amount = withdrawal_amount
    @balance = balance
  end
end 