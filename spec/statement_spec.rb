
require 'statement'

describe Statement do
  let(:statement) { Statement.new }

  it 'has a statement header constant' do
    expect(Statement::STATEMENT_HEADER).to eq "date || credit || debit || balance\n"
  end

  describe '#format_transaction' do
    it 'returns a formatted deposit' do
      expect(statement.format_transaction(["01/09/2008", "1.00", nil, "1.00"])).to eq "01/09/2008 || 1.00 || || 1.00\n"
    end

    it 'returns a formatted withdrawal from the transactions hash' do
      expect(statement.format_transaction(["01/09/2008", nil, "1.00", "-1.00"])).to eq "01/09/2008 || || 1.00 || -1.00\n"
    end
  end
end