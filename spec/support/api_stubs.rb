module ApiStubs
  def mock_api(opts={})
    # Continuning this when spies are added to rspec-mocks: https://github.com/rspec/rspec-mocks/pull/241
    redis_status = opts['redis_status'] || true
    rabbitmq_status = opts['rabbitmq_status'] || true
    status = JSON.parse("{\"sensu\":{\"version\":\"0.9.12.beta.6\"},\"rabbitmq\":{\"keepalives\":{\"messages\":null,\"consumers\":null},\"results\":{\"messages\":null,\"consumers\":null},\"connected\":#{rabbitmq_status}},\"redis\":{\"connected\":#{redis_status}}}")

    @api = double('Api')
    @api.stub(:status).with(status)
    @api.stub(:version).with(status['sensu']['version'])
    @api.stub(:redis_health).with(status['redis']['connected'])
    @api.stub(:rabbitmq_health).with(status['rabbitmq']['connected'])
  end

end
