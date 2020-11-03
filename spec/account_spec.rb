# frozen_string_literal: true

# rubocop:disable all
require './spec/spec_methods'
require 'timecop'
require 'account'
describe Account do
  let(:account) { Account.new }

  it 'initializes with a balance of 0' do
    expect(account.balance).to eq 0
  end

  it 'initializes with an empty array to track withdrawals and deposits' do
    expect(account.transactions).to be_an_instance_of(Hash)
  end

  describe '#transactions' do
    it 'has a withdrawals key containing an array' do
      expect(account.transactions[:withdrawals]).to eq []
    end

    it 'has a deposits key containing an array' do
      expect(account.transactions[:deposits]).to eq []
    end
  end

  describe '#deposit' do
    it 'takes one parameter' do
      expect(account).to respond_to(:deposit).with(1).arguments
    end

    it 'increases the account balance' do
      account.deposit(500)
      expect(account.balance).to eq 500
    end
  end

  describe '#withdraw' do
    it 'takes one parameter' do
      expect(account).to respond_to(:withdraw).with(1).arguments
    end

    it 'decreases the balance by the withdrawal amount' do
      account.deposit(500)
      account.withdraw(499)
      expect(account.balance).to eq 1
    end
  end

  describe 'formatted_date' do
    it 'returns the date in the correct format' do
      set_time(2008, 9, 1)

      expect(account.formatted_date).to eq '01/09/2008'
    end
  end

  describe 'process_transaction' do
    it 'adds a deposit to the transactions hash' do
      set_time(2008, 9, 1)
      account.deposit(500)
      expect(account.transactions[:deposits]).to eq [['01/09/2008', '500.00', nil, '500.00']]
    end

    it 'adds a withdrawal to the transactions hash' do
      set_time(2008, 9, 1)
      account.withdraw(1)
      account.withdraw(5)
      output = [['01/09/2008', nil, '1.00', '-1.00'], ['01/09/2008', nil, '5.00', '-6.00']]
      expect(account.transactions[:withdrawals]).to eq output
    end
  end

  describe '#arrange_transaction_by_date' do
    it 'returns transactions newest first' do
      set_time(2008, 9, 1)
      account.deposit(10)
      set_time(2009, 9, 1)
      account.withdraw(5)
      set_time(2001, 9, 1)
      account.deposit(5)
      output = [['01/09/2009', nil, '5.00', '5.00'], ['01/09/2008', '10.00', nil, '10.00'], ['01/09/2001', '5.00', nil, '10.00']]
      expect(account.arrange_transaction_by_date).to eq(output)
    end

    it 'returns transactions with decimals in the correct format' do
      set_time(2012, 1, 10)
      account.deposit(1000.5)
      set_time(2012, 1, 13)
      account.deposit(2000)
      set_time(2012, 1, 14)
      account.withdraw(500.41)
      output = [['14/01/2012', nil, '500.41', '2500.09'], ['13/01/2012', '2000.00', nil, '3000.50'], ['10/01/2012', '1000.50', nil, '1000.50']]
      expect(account.arrange_transaction_by_date).to eq(output)
    end
  end

  describe 'statement' do
    it 'calls an instance of Statement' do
      statement_double = double :statement, format_transaction: 'formatted', print_bank_statement: 'formatted statement'
      statement_class_double = double :statement_class, new: statement_double
      expect(statement_class_double).to receive(:new)
      account.statement(statement_class_double)
    end

    it 'calls the statement.print_bank_statement method' do
      statement_double = double :statement, print_bank_statement: 'formatted statement'
      statement_class_double = double :statement_class, new: statement_double
      expect(statement_double).to receive(:print_bank_statement)
      account.statement(statement_class_double)
    end
    it 'prints the statement to the console' do
      statement_double = double :statement, print_bank_statement: 'formatted statement'
      statement_class_double = double :statement_class, new: statement_double
      expect(STDOUT).to receive(:puts).with('formatted statement')
      account.statement(statement_class_double)
    end
  end
end
# rubocop:enable all
