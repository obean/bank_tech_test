def set_time(year, month, day, hour, minute, second)
  time = Time.local(year, month, day, hour, minute, second)
  Timecop.travel(time)
end