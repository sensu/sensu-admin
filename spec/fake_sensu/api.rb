require 'sinatra'
require 'json'

class FakeSensu < Sinatra::Base

  def initialize
    super
    @info = '{"sensu":{"version":"0.9.12.beta.6"},"rabbitmq":{"keepalives":{"messages":null,"consumers":null},"results":{"messages":null,"consumers":null},"connected":false},"redis":{"connected":true}}'
    @clients = '[{"name":"i-424242","address":"127.0.0.1","subscriptions":["test"],"nested":{"attribute":true},"timestamp":1364343737}]'
    @checks = '[{"command":"echo -n OK","subscribers":["test"],"interval":60,"name":"test"}]'
    @events = '[{"output":"i-424242 true","status":2,"issued":1364343741,"handlers":["default"],"flapping":false,"occurrences":11828,"client":"i-424242","check":"tokens"},{"output":"foobar","status":1,"issued":1364343741,"handlers":["default"],"flapping":false,"occurrences":11828,"client":"i-424242","check":"standalone"}]'
    @stashes = '[{"path":"silence/i-424242/tokens","content":{"timestamp":1364332102}},{"path":"silence/i-424242/standalone","content":{"timestamp":1364332111}}]'
  end

  get '/info' do
    content_type :json
    @info
  end

  get '/clients' do
    content_type :json
    @clients
  end

  get %r{/clients/([\w\.-]+)$} do |client_name|
    content_type :json
    clients = JSON.parse(@clients)
    clients.each do |client|
      clients.each do |client|
        if client.has_value? client_name
          @body = client.reject! {|k| k == "name"}
        end
      end
    end
    @body ? "#{@body}" : ""
  end

  get '/checks' do
    content_type :json
    @checks
  end
  
  get %r{/checks?/([\w\.-]+)$} do |check_name|
    content_type :json
    checks = JSON.parse(@checks)
    checks.each do |check|
      if check.has_value? check_name
        @body = check 
      end
    end
    @body ? "#{@body}" : ""
  end

  get '/events' do
    content_type :json
    @events
  end

  get %r{/events/([\w\.-]+)$} do |client_name|
    content_type :json
    events = JSON.parse(@events)
    events.each do |event|
      if event.has_value? client_name
        @body = event
      end
    end
    @body ? "#{@body}" : ""
  end

  get '/stashes' do
    content_type :json
    @stashes
  end

  get %r{/stash(?:es)?/(.*)} do |path|
    content_type :json
    stashes = JSON.parse(@stashes)
    stashes.each do |stash|
      if stash.has_value? path
        @body = stash["content"]
      end
    end
    @body ? "#{@body}" : ""
  end

end

FakeSensu.run!
