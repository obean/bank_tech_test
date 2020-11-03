# frozen_string_literal: true

def set_time(year, month, day)
  time = Time.local(year, month, day)
  Timecop.travel(time)
end
