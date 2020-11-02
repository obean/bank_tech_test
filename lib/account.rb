# frozen_string_literal: true

# account class to complete bank tech test
class Account
  attr_reader :balance

  STATEMENT_HEADER = 'date || credit || debit || balance'

  def initialize
    @balance = 0
  end

  def deposit(deposit_amount)
  end
end
