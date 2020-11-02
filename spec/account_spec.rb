# frozen_string_literal: true

require 'timecop'
require 'account'
describe Account do
  let(:account) { Account.new }

  it 'has a statement header constant' do
    expect(Account::STATEMENT_HEADER).to eq "date || credit || debit || balance\n"
  end

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
  # TODO include decimal points.
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
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      expect(account.formatted_date).to eq '01/09/2008'
    end
  end

  describe 'process_transaction' do
    it 'adds a deposit to the transactions hash' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(500)
      expect(account.transactions[:deposits]).to eq [['01/09/2008', 500, nil, 500]]
    end

    it 'adds a withdrawal to the transactions hash' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.withdraw(1)
      account.withdraw(5)
      expect(account.transactions[:withdrawals]).to eq [['01/09/2008', nil, 1, -1], ['01/09/2008', nil, 5, -6]]
    end
  end

  describe '#format_transaction' do
    it 'returns a formatted deposit from the transactions hash' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(1)
      expect(account.format_transaction(account.transactions[:deposits][0])).to eq "01/09/2008 || 1 || || 1\n"
    end

    it 'returns a formatted withdrawal from the transactions hash' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.withdraw(1)
      expect(account.format_transaction(account.transactions[:withdrawals][0])).to eq "01/09/2008 || || 1 || -1\n"
    end
  end

  describe '#arrange_transaction_by_date' do
    it 'returns transactions newest first' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(10)
      time = Time.local(2009, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.withdraw(5)
      time = Time.local(2001, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(5)
      expect(account.arrange_transaction_by_date).to eq ([["01/09/2009", nil, 5, 5], ["01/09/2008", 10, nil, 10], ["01/09/2001", 5, nil, 10]])
    end
  end

  describe 'print_bank_statement' do
    it 'prints out the header when there are no transactions' do
    expect(account.print_bank_statement).to eq "date || credit || debit || balance\n"
    end

    it 'prints out the header with a single transaction' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(500)
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n01/09/2008 || 500 || || 500\n"
    end

    it 'prints out multiple transactions of the same type' do
      time = Time.local(2008, 9, 1, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(500)
      account.deposit(1000)
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n01/09/2008 || 500 || || 500\n01/09/2008 || 1000 || || 1500\n"
    end

    it 'prints our multiple transactions of different types' do
      time = Time.local(2012, 1, 10, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(1000)
      time = Time.local(2012, 1, 13, 10, 5, 0)
      Timecop.travel(time)
      account.deposit(2000)
      time = Time.local(2012, 1, 14, 10, 5, 0)
      Timecop.travel(time)
      account.withdraw(500)
      expect(account.balance).to eq 2500
      expect(account.print_bank_statement).to eq "date || credit || debit || balance\n14/01/2012 || || 500.00 || 2500.00\n13/01/2012 || 2000.00 || || 3000.00\n10/01/2012 || 1000.00 || || 1000.00"
    end
  end
end


