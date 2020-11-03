# frozen_string_literal: true

# account class to complete bank tech test
class Statement
  STATEMENT_HEADER = "date || credit || debit || balance\n"

  def format_transaction(transaction)
    deposit_format = "#{transaction[0]} || #{transaction[1]} || || #{transaction[3]}\n"
    withdrawal_format = "#{transaction[0]} || || #{transaction[2]} || #{transaction[3]}\n"
    transaction[2].nil? ? deposit_format : withdrawal_format
  end

  def print_bank_statement(account_transactions)
    statement = account_transactions.map { |transaction| format_transaction(transaction) }.join
    STATEMENT_HEADER + statement.strip
  end
end
