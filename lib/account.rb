# frozen_string_literal: true

require 'date'

# account class to complete bank tech test
class Account
  attr_reader :balance, :transactions

  STATEMENT_HEADER = "date || credit || debit || balance\n"

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
    if transaction_type == :withdrawals 
      @transactions[transaction_type].push([formatted_date, nil, value, @balance])
    elsif transaction_type == :deposits
      @transactions[transaction_type].push([formatted_date, value, nil, @balance])
    end 
  end

  def format_transaction(transaction)
    transaction[2].nil? ? "#{transaction[0]} || #{transaction[1]} || || #{transaction[3]}\n" : "#{transaction[0]} || || #{transaction[2]} || #{transaction[3]}\n"
  end

  def arrange_transaction_by_date
    @transactions.values
                 .flatten(1)
                 .sort { |a,b| Date.parse(a[0]) <=> Date.parse(b[0])}
  end

  def print_bank_statement
    deposits = @transactions[:deposits].map{ |deposit| format_transaction(deposit)}
    withdrawals = @transactions[:withdrawals].map {|withdrawal| format_transaction(withdrawal)}
    STATEMENT_HEADER  + deposits.join
  end
end
