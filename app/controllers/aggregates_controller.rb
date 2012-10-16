class AggregatesController < ApplicationController
  def index
    @aggregates = Aggregate.full_hash
  end
end
