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
    it 'adds a deposit transaction object to the transactions hash' do
      transaction_instance_double = double :transaction, date: '01/09/2008', deposit_amount: '500.00', withdrawal_amount: nil, balance: '500.00'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.deposit(500, transaction_class_double)
      expect(account.transactions[:deposits].first.date).to eq '01/09/2008'
      expect(account.transactions[:deposits].first.deposit_amount).to eq '500.00'
      expect(account.transactions[:deposits].first.withdrawal_amount).to eq nil
      expect(account.transactions[:deposits].first.balance).to eq '500.00'
    end

    it 'adds a withdrawal to the transactions hash' do
      transaction_instance_double = double :transaction, date: '01/09/2008', deposit_amount: nil, withdrawal_amount: '500.00', balance: '-500.00'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.withdraw(1, transaction_class_double)
      expect(account.transactions[:withdrawals].first.date).to eq '01/09/2008'
      expect(account.transactions[:withdrawals].first.deposit_amount).to eq nil
      expect(account.transactions[:withdrawals].first.withdrawal_amount).to eq '500.00'
      expect(account.transactions[:withdrawals].first.balance).to eq '-500.00'
    end
  end

  describe '#arrange_transaction_by_date' do
    it 'returns transactions newest first' do
      transaction_instance_double = double :transaction, date: '01/09/2001'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.deposit(10, transaction_class_double)

      transaction_instance_double = double :transaction, date: '01/09/2009'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.withdraw(5, transaction_class_double)

      transaction_instance_double = double :transaction, date: '01/09/2008'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.deposit(5, transaction_class_double)

      expect(account.arrange_transaction_by_date.first.date).to eq '01/09/2009'
      expect(account.arrange_transaction_by_date[1].date).to eq '01/09/2008'
      expect(account.arrange_transaction_by_date.last.date).to eq '01/09/2001'
    end

    it 'returns transactions which only differ by days in the correct order' do
      transaction_instance_double = double :transaction, date: '10/01/2012', deposit_amount: '1000.50', withdrawal_amount: nil, balance: '1000.50'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.deposit(1000.5, transaction_class_double)
      transaction_instance_double = double :transaction, date: '13/01/2012', deposit_amount: '2000.00', withdrawal_amount: nil, balance: '3000.50'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.deposit(2000, transaction_class_double)
      transaction_instance_double = double :transaction, date: '14/01/2012', deposit_amount: nil, withdrawal_amount: '500.41', balance: '2500.09'
      transaction_class_double = double :transaction_class, new: transaction_instance_double
      account.withdraw(500.41, transaction_class_double)
      expect(account.arrange_transaction_by_date.first.withdrawal_amount).to eq '500.41'
      expect(account.arrange_transaction_by_date[1].deposit_amount).to eq '2000.00'
      expect(account.arrange_transaction_by_date.last.deposit_amount).to eq '1000.50'
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
