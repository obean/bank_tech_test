require 'transaction'

describe Transaction do
  let(:transaction) { Transaction.new(Time.now.strftime('%d/%m/%Y'), 1, nil, 1) }
  it 'intitializes with a date, deposit_amount, withdrawal_amount and balance' do
    expect(transaction.date).to match /\d{2}\/\d{2}\/\d{4}/
    expect(transaction.deposit_amount).to eq 1
    expect(transaction.withdrawal_amount).to eq nil
    expect(transaction.balance).to eq 1
  end 
  end
