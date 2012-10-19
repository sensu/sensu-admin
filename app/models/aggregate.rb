class Aggregate < Resting
  def self.full_hash
    begin
      resp_hash = {}
      Aggregate.all.each do |agg|
        resp_hash[agg.check] = {}
        agg.issued.each do |issue|
          resp_hash[agg.check][issue] = Aggregate.get("aggregates/#{agg.check}/#{issue}?summarize=output", true)
        end
      end
      resp_hash
    rescue NoMethodError
      # If API does not support Aggregates, this raises up to the view. We need a better way of handling feature updates.
      false
    end
  end
end
