
class Statement 

  STATEMENT_HEADER = "date || credit || debit || balance\n"

  def format_transaction(transaction)
    transaction[2].nil? ? "#{transaction[0]} || #{transaction[1]} || || #{transaction[3]}\n" : "#{transaction[0]} || || #{transaction[2]} || #{transaction[3]}\n"
  end

  def print_bank_statement(account_transactions)
    statement = account_transactions.map { |transaction| format_transaction(transaction) }.join
    Statement::STATEMENT_HEADER + statement.strip
  end

end