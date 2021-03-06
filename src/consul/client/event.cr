require "../types/*"
require "../transport"

module Consul
  class Event < Consul::Transport
    # create_event triggers a new user event
    def create_event(
      name : String,
      data : String,
      datacenter : String? = nil,
      node : String? = nil,
      service : String? = nil,
      tag : String? = nil
    ) : Consul::Types::Event::Event
      endpoint = "/v1/event/fire/#{name}"

      val = Consul::Util.build_query_params({
        "dc"      => datacenter,
        "node"    => node,
        "service" => service,
        "tag"     => tag,
      })

      if val
        endpoint = "#{endpoint}#{val}"
      end

      resp = put("/v1/event/fire/#{name}", data: data)
      return Consul::Types::Event::Event.from_json(resp.body)
    end

    # get_events returns the most recent events (up to 256) known by the agent
    def get_events(
      name : String? = nil,
      node : String? = nil,
      service : String? = nil,
      tag : String? = nil
    ) : Array(Consul::Types::Event::Event)
      endpoint = "/v1/event/list"

      val = Consul::Util.build_query_params({
        "name"    => name,
        "node"    => node,
        "service" => service,
        "tag"     => tag,
      })

      if val
        endpoint = "#{endpoint}#{val}"
      end

      resp = get(endpoint)
      return Array(Consul::Types::Event::Event).from_json(resp.body)
    end
  end
end
