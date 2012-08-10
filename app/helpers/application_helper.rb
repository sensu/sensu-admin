module ApplicationHelper
  def format_status(status)
    case status
    when 1, "1"
      "Critical"
    when 2, "2"
      "Warning"
    else
      "Unknown"
    end
  end

  def format_output(output, maxlen = 80)
    return "" if output.nil?
    (output.length > maxlen) ? "#{output[0..(maxlen - 3)]}..." : output
  end
end
