# frozen_string_literal: true

# Statement class to return formatted bank statement
class Statement
  STATEMENT_HEADER = "date || credit || debit || balance\n"

  def format_transaction(transaction)
    deposit_format = "#{transaction.date} || #{transaction.deposit_amount} || || #{transaction.balance}\n"
    withdrawal_format = "#{transaction.date} || || #{transaction.withdrawal_amount} || #{transaction.balance}\n"
    transaction.withdrawal_amount.nil? ? deposit_format : withdrawal_format
  end

  def print_bank_statement(account_transactions)
    statement = account_transactions.map { |transaction| format_transaction(transaction) }.join
    STATEMENT_HEADER + statement.strip
  end
end
