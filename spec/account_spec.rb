# frozen_string_literal: true

require 'account'
describe Account do
  let(:account) { Account.new }

  it 'has a statement header constant' do
    expect(Account::STATEMENT_HEADER).to eq 'date || credit || debit || balance'
  end

  it 'initializes with a balance of 0' do
    expect(account.balance).to eq 0
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
end
