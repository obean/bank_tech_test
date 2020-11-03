# frozen_string_literal: true

def set_time(year, month, day)
  time = Time.local(year, month, day)
  Timecop.travel(time)
end

def double_builder(expected_array)
  "transaction_double = double :transaction, date: '#{expected_array[0]}', deposit_amount: '#{expected_array[1].to_s}', withdrawal_amount: '#{expected_array[2].to_s}', balance: '#{expected_array[3].to_s}'"
end