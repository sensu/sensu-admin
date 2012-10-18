class Aggregate < Resting
  def self.full_hash
    resp_hash = {}
    Aggregate.all.each do |agg|
      resp_hash[agg.check] = {}
      agg.issued.each do |issue|
        resp_hash[agg.check][issue] = Aggregate.get("aggregates/#{agg.check}/#{issue}?summarize=output", true)
      end
    end
    resp_hash
  end
end
