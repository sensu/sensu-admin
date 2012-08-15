module ApplicationHelper
  def format_status(status)
    case status
    when 2, "2"
      "Critical"
    when 1, "1"
      "Warning"
    else
      "Unknown"
    end
  end

  def format_output(output, maxlen = 50)
    return "" if output.nil?
    (output.length > maxlen) ? "#{output[0..(maxlen - 3)]}..." : output
  end

  def downtime_number
    count = Downtime.active.count
    (count > 0) ? "(#{count})" : ""
  end
end
