# frozen_string_literal: true
require './spec/spec_methods.rb'
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
  # TODO: include decimal points.
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
      set_time(2008, 9, 1, 10, 5, 0)
      
      expect(account.formatted_date).to eq '01/09/2008'
    end
  end

  describe 'process_transaction' do
    it 'adds a deposit to the transactions hash' do
     set_time(2008, 9, 1, 10, 5, 0)
      
      account.deposit(500)
      expect(account.transactions[:deposits]).to eq [['01/09/2008', '500.00', nil, '500.00']]
    end

    it 'adds a withdrawal to the transactions hash' do
      set_time(2008, 9, 1, 10, 5, 0)
      account.withdraw(1)
      account.withdraw(5)
      expect(account.transactions[:withdrawals]).to eq [['01/09/2008', nil, '1.00', '-1.00'], ['01/09/2008', nil, '5.00', '-6.00']]
    end
  end



  describe '#arrange_transaction_by_date' do
    it 'returns transactions newest first' do
      set_time(2008, 9, 1, 10, 5, 0)
      account.deposit(10)
      set_time(2009, 9, 1, 10, 5, 0)
      account.withdraw(5)
      set_time(2001, 9, 1, 10, 5, 0)
      account.deposit(5)
      expect(account.arrange_transaction_by_date).to eq([['01/09/2009', nil, '5.00', '5.00'], ['01/09/2008', '10.00', nil, '10.00'], ['01/09/2001', '5.00', nil, '10.00']])
    end
  end

  describe 'print_bank_statement' do
    it 'prints out the header when there are no transactions' do
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n"
    end

    it 'prints out the header with a single transaction' do
      set_time(2008, 9, 1, 10, 5, 0)
      account.deposit(500)
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00"
    end

    it 'prints out multiple transactions of the same type' do
      set_time(2008, 9, 1, 10, 5, 0)
      account.deposit(500)
      account.deposit(1000)
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n01/09/2008 || 500.00 || || 500.00\n01/09/2008 || 1000.00 || || 1500.00"
    end

    it 'prints our multiple transactions of different types' do
      set_time(2012, 1, 10, 10, 5, 0)
      account.deposit(1000)
      set_time(2012, 1, 13, 10, 5, 0)
      account.deposit(2000)
      set_time(2012, 1, 14, 10, 5, 0)
      account.withdraw(500)
      expect(account.balance).to eq 2500
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00"
    end

    it 'works with decimals' do
      set_time(2012, 1, 10, 10, 5, 0)
      account.deposit(1000.5)
      set_time(2012, 1, 13, 10, 5, 0)
      account.deposit(2000)
      set_time(2012, 1, 14, 10, 5, 0)
      account.withdraw(500.41)
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n14/01/2012 || || 500.41 || 2500.09\n13/01/2012 || 2000.00 || || 3000.50\n10/01/2012 || 1000.50 || || 1000.50"
    end
  end
end
