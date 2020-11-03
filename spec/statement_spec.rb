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
      transaction_double = double :transaction, date: '01/09/2008', deposit_amount: '500.00', withdrawal_amount: nil, balance: '500.00'
      expect(statement.print_bank_statement([transaction_double])).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00"
    end

    it 'prints out multiple transactions of the same type' do
      transaction_double1 = double :transaction, date: '01/09/2008', deposit_amount: '500.00', withdrawal_amount: nil, balance: '500.00'
      transaction_double2 = double :transaction, date: '01/09/2008', deposit_amount: '1000.00', withdrawal_amount: nil, balance: '1500.00'
      expect(statement.print_bank_statement([transaction_double1, transaction_double2])).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00\n01/09/2008 || 1000.00 || || 1500.00"
    end

    it 'prints out multiple transactions of different types' do
      transaction_double1 = double :transaction, date: '14/01/2012', deposit_amount: nil, withdrawal_amount: '500.00', balance: '2500.00'
      transaction_double2 = double :transaction, date: '13/01/2012', deposit_amount: '2000.00', withdrawal_amount: nil, balance: '3000.00'
      transaction_double3 = double :transaction, date: '10/01/2012', deposit_amount: '1000.00', withdrawal_amount: nil, balance: '1000.00'
      output = [transaction_double1, transaction_double2, transaction_double3]
      expect(statement.print_bank_statement(output)).to eq "date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00"
    end

    it 'works with decimals' do
      transaction_double1 = double :transaction, date: '14/01/2012', deposit_amount: nil, withdrawal_amount: '500.41', balance: '2500.09'
      transaction_double2 = double :transaction, date: '13/01/2012', deposit_amount: '2000.00', withdrawal_amount: nil, balance: '3000.50'
      transaction_double3 = double :transaction, date: '10/01/2012', deposit_amount: '1000.50', withdrawal_amount: nil, balance: '1000.50'
      output = [transaction_double1, transaction_double2, transaction_double3]
      expect(statement.print_bank_statement(output)).to eq "date || credit || debit || balance\n14/01/2012 || || 500.41 || 2500.09\n13/01/2012 || 2000.00 || || 3000.50\n10/01/2012 || 1000.50 || || 1000.50"
    end
  end
end
# rubocop:enable all
