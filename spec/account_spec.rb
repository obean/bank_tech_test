describe Account do
  let(:account){ Account.new }
  it "prints the table header when no deposit has been made" do
    expect(account.print_statement).to eq "date || credit || debit || balance"
  end


end
