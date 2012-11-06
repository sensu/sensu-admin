class Check < Resting

  def self.submit_check(check, subscribers)
    poster = post("check/request", {:check => check, :subscribers => subscribers })
    poster.code == 201
  end

  def method_missing(method, *args, &block)
    "None"
  end
end
