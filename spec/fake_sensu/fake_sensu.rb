require 'sinatra'
require 'json'

class FakeSensu < Sinatra::Base

  configure do
    set :logging, true
    set :info, "{\"sensu\":{\"version\":\"0.9.12.beta.6\"},\"rabbitmq\":{\"keepalives\":{\"messages\":null,\"consumers\":null},\"results\":{\"messages\":null,\"consumers\":null},\"connected\":false},\"redis\":{\"connected\":true}}"
    set :clients, "[{\"name\":\"i-424242\",\"address\":\"127.0.0.1\",\"subscriptions\":[\"test\"],\"nested\":{\"attribute\":true},\"timestamp\":1364343737}]"
    set :checks, "[{\"command\":\"echo -n OK\",\"subscribers\":[\"test\"],\"interval\":60,\"name\":\"test\"},{\"command\":\"echo -n OK\",\"subscribers\":[\"tokens\"],\"interval\":60,\"name\":\"tokens\"}]"
    set :events, "[{\"output\":\"i-424242 true\",\"status\":2,\"issued\":1364343741,\"handlers\":[\"default\"],\"flapping\":false,\"occurrences\":11828,\"client\":\"i-424242\",\"check\":\"tokens\"},{\"output\":\"foobar\",\"status\":1,\"issued\":1364343741,\"handlers\":[\"default\"],\"flapping\":false,\"occurrences\":11828,\"client\":\"i-424242\",\"check\":\"standalone\"}]"
    set :stashes, "[{\"path\":\"silence/i-424242/tokens\",\"content\":{\"timestamp\":1364332102}},{\"path\":\"silence/i-424242/standalone\",\"content\":{\"timestamp\":1364332111}}]"
    # the content of the immutable settings should be identical to the settings
    # above. they are used for the reset action
    set :immutable_info, "{\"sensu\":{\"version\":\"0.9.12.beta.6\"},\"rabbitmq\":{\"keepalives\":{\"messages\":null,\"consumers\":null},\"results\":{\"messages\":null,\"consumers\":null},\"connected\":false},\"redis\":{\"connected\":true}}".freeze
    set :immutable_clients, "[{\"name\":\"i-424242\",\"address\":\"127.0.0.1\",\"subscriptions\":[\"test\"],\"nested\":{\"attribute\":true},\"timestamp\":1364343737}]".freeze
    set :immutable_checks, "[{\"command\":\"echo -n OK\",\"subscribers\":[\"test\"],\"interval\":60,\"name\":\"test\"},{\"command\":\"echo -n OK\",\"subscribers\":[\"tokens\"],\"interval\":60,\"name\":\"tokens\"}]".freeze
    set :immutable_events, "[{\"output\":\"i-424242 true\",\"status\":2,\"issued\":1364343741,\"handlers\":[\"default\"],\"flapping\":false,\"occurrences\":11828,\"client\":\"i-424242\",\"check\":\"tokens\"},{\"output\":\"foobar\",\"status\":1,\"issued\":1364343741,\"handlers\":[\"default\"],\"flapping\":false,\"occurrences\":11828,\"client\":\"i-424242\",\"check\":\"standalone\"}]".freeze
    set :immutable_stashes, "[{\"path\":\"silence/i-424242/tokens\",\"content\":{\"timestamp\":1364332102}},{\"path\":\"silence/i-424242/standalone\",\"content\":{\"timestamp\":1364332111}}]".freeze
  end

  get '/info' do
    content_type :json
    body settings.info
  end

  get '/clients' do
    content_type :json
    settings.clients
  end

  get %r{/clients/([\w\.-]+)$} do |client_name|
    content_type :json
    clients = JSON.parse(settings.clients)
    clients.each do |client|
      clients.each do |client|
        if client.has_value? client_name
          @body = client.reject! {|k| k == "name"}.to_json
        end
      end
    end
    @body ? "#{@body}" : ""
  end

  get '/checks' do
    content_type :json
    settings.checks
  end
  
  get %r{/checks?/([\w\.-]+)$} do |check_name|
    content_type :json
    checks = JSON.parse(settings.checks)
    checks.each do |check|
      if check.has_value? check_name
        @body = check.to_json
      end
    end
    @body ? "#{@body}" : ""
  end

  post %r{/(?:check/)?request$} do
    post_body = JSON.parse(request.body.read)
    check_name = post_body["check"]
    check = post_body["check"]
    subscribers = check["subscribers"].to_a 
    command = check["command"]
    payload = {
      :name => check_name,
      :command => command,
      :issued => Time.now.to_i
    }
    body payload
  end

  get '/events' do
    content_type :json
    body settings.events
  end

  get %r{/events/([\w\.-]+)$} do |client_name|
    content_type :json
    events = JSON.parse(settings.events)
    events.each do |event|
      if event.has_value? client_name
        @body = event.to_json
      end
    end
    @body ? "#{@body}" : ""
  end

  get %r{/events?/([\w\.-]+)/([\w\.-]+)$} do |client_name, check_name|
    content_type :json
    event_json = settings.events[client_name]
    unless event_json.nil?
      event_json[:client_name] = check
      event_json[:check_name] = check_name 
      @body = event_json
    end
  end

  delete %r{/events?/([\w\.-]+)/([\w\.-]+)$} do |client_name, check_name|
    content_type :json
    events = JSON.parse(settings.events)
    events.each do |event|
      if event["client"] == client_name && event["check"] == check_name
        events.delete_if {|e| e.has_value? check_name}
        # settings.events = events.to_s
      end
    end
    body ''
  end

  get '/stashes' do
    content_type :json
    body settings.stashes
  end

  get %r{/stash(?:es)?/(.*)} do |path|
    content_type :json
    stashes = JSON.parse(settings.stashes)
    stashes.each do |stash|
      if stash.has_value? path
        @body = stash["content"]
      end
    end
    @body ? "#{@body}" : ""
  end
  
  post %r{/stash(?:es)?/(.*)} do |path|
    content_type :json
    stashes = JSON.parse(settings.stashes)
    stashes = stashes + [{"path" => path, "content" => {"timestamp" => Time.now.to_i}}]
    settings.stashes = stashes.to_json
    body ''
  end

  post '/stashes' do 
    content_type :json
    post_body = JSON.parse(request.body.read)
    path = post_body["path"]
    content = post_body["content"]
    stashes = JSON.parse(settings.stashes)
    stashes = stashes + [{"path" => path, "content" => content}]
    settings.stashes = stashes.to_json
  end

  delete %r{/stash(?:es)?/(.*)} do |path|
    content_type :json
    stashes = JSON.parse(settings.stashes) 
    stashes.each do |stash|
      if stash.has_value? path
        stashes.delete_if {|stash| stash.has_value? path}
        settings.stashes = stashes.to_json
        body = ''
      else
        body = 'not found'
      end
    end
    body
  end

  get '/reset' do
    settings.info = settings.immutable_info
    settings.clients = settings.immutable_clients
    settings.checks = settings.immutable_checks
    settings.events = settings.immutable_events
    settings.stashes = settings.immutable_stashes
    body ''
  end

end
