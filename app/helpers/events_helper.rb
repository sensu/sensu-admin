module EventsHelper
  def format_status(status)
    case status
    when 1
      "Critical"
    when 2
      "Warning"
    else
      "Unknown"
    end
  end

  def format_output(output)
    maxlen = 80
    (output.length > maxlen) ? "#{output[0..(maxlen - 3)]}..." : output
  end

  def silenced_output(data)
    (data.nil?) ? "Not Silenced" : "#{data['description']} - #{data['owner']} - #{data['timestamp']}"
  end

  def display_silenced(silenced, event, type)
    volume_display = (silenced.nil? ? "up" : "off")
    rel = (type == :client ? "#{event.client}_icon_silenced" : "#{event.client}_#{event.check}_icon_silenced")
    haml_tag(:i, {:class => "icon-volume-#{volume_display}", :rel => rel })
  end
end
