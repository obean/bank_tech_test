# frozen_string_literal: true

# account class to complete bank tech test
class Account
  attr_reader :balance

  STATEMENT_HEADER = 'date || credit || debit || balance'

  def initialize
    @balance = 0
  end

  def deposit(deposit_amount)
    @balance += deposit_amount
  end

  def withdraw(withdrawal_amount)
    @balance -= withdrawal_amount
  end

  def formatted_date
    Time.now.strftime('%d/%m/%Y')
  end
end
