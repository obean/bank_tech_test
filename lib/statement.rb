
class Statement 

  STATEMENT_HEADER = "date || credit || debit || balance\n"

  def format_transaction(transaction)
    transaction[2].nil? ? "#{transaction[0]} || #{transaction[1]} || || #{transaction[3]}\n" : "#{transaction[0]} || || #{transaction[2]} || #{transaction[3]}\n"
  end
end