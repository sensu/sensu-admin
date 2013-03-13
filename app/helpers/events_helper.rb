module EventsHelper

  def silenced_output(check, client)
    # TODO: This should be all haml_tag's
    output = ""
    output << "Check silenced by:<br>" unless check.nil?
    output << "#{check['description']} - #{check['owner']} - #{check['timestamp']}<br>" unless check.nil?
    output << "Client silenced by:<br>" unless client.nil?
    output << "#{client['description']} - #{client['owner']} - #{client['timestamp']}<br>" unless client.nil?
    output << "Not Silenced" if client.nil? && check.nil?
    output
  end

  def display_silenced(event, i)
    # If client_silenced is nil, that means its not silenced
    voldisp = ((event.client_silenced.nil? && event.check_silenced.nil?) ? "up" : "off")
    haml_tag(:i, {:class => "icon-volume-#{voldisp}", :rel => "icon_silenced_#{i}", :style => "color: #2c2c2c; text-shadow: none;"})
  end

  def is_nil?(obj)
    obj.nil? ? "true" : "false"
  end

  def not_nil?(obj)
    obj.nil? ? "false" : "true"
  end

  def is_url?(str)
    require 'uri'
    str =~ URI::ABS_URI ? true : false
  end

  def anchor_wrap_if_url(str)
    if is_url?(str)
      content_tag(:a, str)
    else
      str
    end
  end

end
