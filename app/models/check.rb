class Check < Resting

  def self.submit_check(check, subscribers)
    poster = post("request", {:check => check, :subscribers => subscribers })
    poster.code == 202
  end

  def method_missing(method, *args, &block)
    "None"
  end
end
