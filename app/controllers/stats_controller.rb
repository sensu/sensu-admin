class StatsController < ApplicationController
  def index
    @events = Event.all_with_cache
    @clients = Client.all_with_cache
    @downtimes = Downtime.all
    @stashes = Stash.all
    @clients_by_subscription = {}
    @clients_by_environment = {}
    @clients.each do |client|
      client.subscriptions.each do |subscription|
        increment(@clients_by_subscription, subscription)
      end
      increment(@clients_by_environment, client.environment)
    end
    @events_by_check = {}
    @events_by_environment = {}
    @events_per_client = {}
    @events.each do |event|
      increment(@events_per_client, event.client)
      increment(@events_by_check, event.check)
      increment(@events_by_environment, event.environment)
    end
  end
end
