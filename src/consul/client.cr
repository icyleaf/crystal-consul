require "./client/*"
require "./agent/*"
require "json"
require "http/client"
require "uri"

module Consul
  class Client

    getter host, port, scheme, token
    getter kv, catalog, status, agent, event, health

    def initialize(
      @host    : String = "127.0.0.1", 
      @port    : Int32 = 8500,
      @scheme  : String = "http",
      @token   : String? = nil    # to be implemented
      )

      client = http_client_instance("#{scheme}://#{host}:#{port}", token)

      @kv      = Consul::KV.new(client)
      @catalog = Consul::Catalog.new(client)
      @status  = Consul::Status.new(client)
      @agent   = Consul::Agent.new(client)
      @event   = Consul::Event.new(client)
      @health  = Consul::Health.new(client)
    end

    private def http_client_instance(uri : String, token : String? = nil) : HTTP::Client
      uri = URI.parse(uri)
      client = HTTP::Client.new(uri)
      client.connect_timeout = 5

      if token
        client.before_request do |request|
          request.headers["X-Consul-Token"] = token
        end
      end

      return client
    end

  end
end
