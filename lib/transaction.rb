# frozen_string_literal: true

# Transaction class to be called by Account on deposit/withdraw
class Transaction
  attr_reader :date, :deposit_amount, :withdrawal_amount, :balance

  def initialize(date, deposit_amount, withdrawal_amount, balance)
    @date = date
    @deposit_amount = deposit_amount
    @withdrawal_amount = withdrawal_amount
    @balance = balance
  end
end 
