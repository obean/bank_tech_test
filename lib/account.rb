# frozen_string_literal: true

require 'date'
require_relative './transaction'
require_relative './statement'
# account class to complete bank tech test
class Account
  attr_reader :balance, :transactions

  def initialize
    @balance = 0
    @transactions = { withdrawals: [], deposits: [] }
  end

  def deposit(deposit_amount, object_class = Transaction)
    @balance += deposit_amount
    process_transaction(:deposits, deposit_amount, object_class)
  end

  def withdraw(withdrawal_amount, object_class=Transaction)
    @balance -= withdrawal_amount
    process_transaction(:withdrawals, withdrawal_amount, object_class)
  end

  def formatted_date
    Time.now.strftime('%d/%m/%Y')
  end

  def process_transaction(transaction_type, value, type)
    case transaction_type
    when :withdrawals
      transaction = type.new(formatted_date, nil, format('%.2f', value), format('%.2f', @balance))
      @transactions[transaction_type].push(transaction)
    when :deposits
      transaction = type.new(formatted_date, format('%.2f', value), nil, format('%.2f', @balance))
      @transactions[transaction_type].push(transaction)
    end
  end

  def arrange_transaction_by_date
    @transactions.values
                 .flatten(1)
                 .sort { |a, b| Date.parse(b.date) <=> Date.parse(a.date) }
  end

  def statement(statement = Statement)
    current_statement = statement.new
    puts current_statement.print_bank_statement(arrange_transaction_by_date)
  end
end
