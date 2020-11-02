require 'account'
describe Account do
  let(:account){ Account.new }

  it "has a statement header constant" do
    expect(Account::STATEMENT_HEADER).to eq "date || credit || debit || balance"
  end


end
