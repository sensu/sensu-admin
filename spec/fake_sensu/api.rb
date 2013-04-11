require 'sinatra'
require 'json'

get '/info' do
  content_type :json
  '{"sensu":{"version":"0.9.12.beta.6"},"rabbitmq":{"keepalives":{"messages":null,"consumers":null},"results":{"messages":null,"consumers":null},"connected":false},"redis":{"connected":true}}'
end

get '/clients' do
  content_type :json
  '[{"name":"i-424242","address":"127.0.0.1","subscriptions":["test"],"nested":{"attribute":true},"timestamp":1364343737}]'
end

get '/checks' do
  content_type :json
  '[{"command":"echo -n OK","subscribers":["test"],"interval":60,"name":"test"}]'
end

get '/events' do
  content_type :json
  '[{"output":"i-424242 true","status":2,"issued":1364343741,"handlers":["default"],"flapping":false,"occurrences":11828,"client":"i-424242","check":"tokens"},{"output":"foobar","status":1,"issued":1364343741,"handlers":["default"],"flapping":false,"occurrences":11828,"client":"i-424242","check":"standalone"}]'
end

get 'stashes' do
  content_type :json
  '[{"path":"silence/i-424242/tokens","content":{"timestamp":1364332102}},{"path":"silence/i-424242/standalone","content":{"timestamp":1364332111}}]'
end
