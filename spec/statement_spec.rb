# frozen_string_literal: true

# rubocop:disable all
require 'statement'

describe Statement do
  let(:statement) { Statement.new }

  it 'has a statement header constant' do
    expect(Statement::STATEMENT_HEADER).to eq "date || credit || debit || balance\n"
  end

  describe '#format_transaction' do
    it 'returns a formatted deposit' do
      expect(statement.format_transaction(['01/09/2008', '1.00', nil, '1.00'])).to eq "01/09/2008 || 1.00 || || 1.00\n"
    end

    it 'returns a formatted withdrawal from the transactions hash' do
      expect(statement.format_transaction(['01/09/2008', nil, '1.00', '-1.00'])).to eq "01/09/2008 || || 1.00 || -1.00\n"
    end
  end

  describe 'print_bank_statement' do
    it 'prints out the header when there are no transactions' do
      expect(statement.print_bank_statement([])).to eq "date || credit || debit || balance\n"
    end

    it 'prints out the header with a single transaction' do
      expect(statement.print_bank_statement([['01/09/2008', '500.00', nil, '500.00']])).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00"
    end

    it 'prints out multiple transactions of the same type' do
      expect(statement.print_bank_statement([['01/09/2008', '500.00', nil, '500.00'], ['01/09/2008', '1000.00', nil, '1500.00']])).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00\n01/09/2008 || 1000.00 || || 1500.00"
    end

    it 'prints out multiple transactions of different types' do
      output = [['14/01/2012', nil, '500.00', '2500.00'], ['13/01/2012', '2000.00', nil, '3000.00'], ['10/01/2012', '1000.00', nil, '1000.00']]
      expect(statement.print_bank_statement(output)).to eq "date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00"
    end

    it 'works with decimals' do
      output = [['14/01/2012', nil, '500.41', '2500.09'], ['13/01/2012', '2000.00', nil, '3000.50'], ['10/01/2012', '1000.50', nil, '1000.50']]
      expect(statement.print_bank_statement(output)).to eq "date || credit || debit || balance\n14/01/2012 || || 500.41 || 2500.09\n13/01/2012 || 2000.00 || || 3000.50\n10/01/2012 || 1000.50 || || 1000.50"
    end
  end
end
# rubocop:enable all
