class SensuJSONFormatter
  include ActiveResource::Formats::JsonFormat

  def decode(json)
    ActiveSupport::JSON.decode({:reply => json}.to_json)
  end
end

class SensuStashFormatter
  include ActiveResource::Formats::JsonFormat

  def decode(json)
    JSON.parse(json).collect do |stash|
      ActiveSupport::JSON.decode({ stash => nil }.to_json)
    end
  end
end
