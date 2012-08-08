class SensuJSONFormatter
  include ActiveResource::Formats::JsonFormat

  def decode(json)
    ActiveSupport::JSON.decode({:reply => json}.to_json)
  end
end
