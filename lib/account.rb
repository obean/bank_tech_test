# frozen_string_literal: true

# account class to complete bank tech test
class Account
  attr_reader :balance, :transactions

  STATEMENT_HEADER = 'date || credit || debit || balance'

  def initialize
    @balance = 0
    @transactions = { withdrawals: [], deposits: [] }
  end

  def deposit(deposit_amount)
    @balance += deposit_amount
    process_transaction(:deposits, deposit_amount)
  end

  def withdraw(withdrawal_amount)
    @balance -= withdrawal_amount
    process_transaction(:withdrawals, withdrawal_amount)
  end

  def formatted_date
    Time.now.strftime('%d/%m/%Y')
  end

  def process_transaction(transaction_type, value)
    @transactions[transaction_type].push([formatted_date, value, @balance])
  end

  

  def print_bank_statement
    deposits = @transactions[:deposits].each {|deposit| deposit.map {|entry| entry.to_s}}
    deposits.each {|deposit| deposit[1] = "#{deposit[1]} ||"}
    STATEMENT_HEADER + "\n" + deposits.join(' || ')
  end
end
