# frozen_string_literal: true

require 'date'
require_relative './statement.rb'
# account class to complete bank tech test
class Account
  attr_reader :balance, :transactions

 

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
      @transactions[transaction_type].push([formatted_date, nil, '%.2f' % value, format('%.2f', @balance)])
    elsif transaction_type == :deposits
      @transactions[transaction_type].push([formatted_date, '%.2f' % value, nil, format('%.2f', @balance)])
    end
  end



  def arrange_transaction_by_date
    @transactions.values
                 .flatten(1)
                 .sort { |a, b| Date.parse(b[0]) <=> Date.parse(a[0]) }
  end

  def statement(statement = Statement)
   current_statement = statement.new
   current_statement.print_bank_statement(arrange_transaction_by_date)
  end


end
