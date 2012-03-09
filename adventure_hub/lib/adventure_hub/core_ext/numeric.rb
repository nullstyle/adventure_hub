class Numeric
  def duration_s
    seconds = ceil
    hours   = seconds / 1.hour
    seconds -= hours * 1.hour
    minutes = seconds / 1.minute
    seconds -= minutes * 1.minute

    hours_s   = "#{hours}h"
    minutes_s = "#{minutes}m" if minutes > 0 || seconds > 0
    seconds_s = "#{seconds}s" if seconds > 0

    "#{hours_s}#{minutes_s}#{seconds_s}"
  end
end