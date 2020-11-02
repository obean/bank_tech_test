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
end
