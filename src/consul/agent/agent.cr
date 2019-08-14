require "uri"
require "../util"
require "../service"
require "../check"

module Consul
  class Agent

    getter client

    def initialize(@client : HTTP::Client)
    end

    # get_services returns all the services that are registered with the local agent
    def get_services() : JSON::Any
      resp = Consul::Util.get(client, "/v1/agent/services")
      return JSON.parse(resp.body)
    end

    # get_service_conf returns the full service definition for a single service instance registered on the local agent
    def get_service_conf(name : String) : Consul::Types::Agent::ServiceConf
      resp = Consul::Util.get(client, "/v1/agent/service/#{name}")
      return Consul::Types::Agent::ServiceConf.from_json(resp.body)
    end

    # get_local_service_health returns an aggregated state of service(s) on the local agent by name
    def get_service_health(name : String) : Array(Consul::Types::Agent::ServiceHealth)
      resp = Consul::Util.get(client, "/v1/agent/health/service/name/#{name}")
      return Array(Consul::Types::Agent::ServiceHealth).from_json(resp.body)
    end

    # register_service adds a new service, with an optional health check, to the local agent
    # TO-DO: implement kind, proxy, connect
    def register_service(service : Consul::Service)
      Consul::Util.put(client, "/v1/agent/service/register", data: service.to_json)
    end

    # deregister_service removes a service from the local agent. If the service does not exist, no action is taken
    def deregister_service(service_id : String)
      # service/deregister/my-service-id
      Consul::Util.put(client, "/v1/agent/service/deregister/#{service_id}")
    end

    # set_serice_maintenence places a given service into "maintenance mode". 
    # During maintenance mode, the service will be marked as unavailable and will not be present in DNS or API queries
    def set_service_maintenenance(service_id : String, enable : Bool, reason = "")
      if reason != ""
        reason = URI.escape(reason)
        Consul::Util.put(client, "/v1/agent/service/maintenance/#{service_id}?enable=#{enable}&reason=#{reason}")
      else
        Consul::Util.put(client, "/v1/agent/service/maintenance/#{service_id}?enable=#{enable}")
      end
    end

    # get_checks returns all checks that are registered with the local agent. 
    def get_checks()
    end

    # register_check adds a new check to the local agent. Checks may be of script, HTTP, TCP, or TTL type. 
    # The agent is responsible for managing the status of the check and keeping the Catalog in sync
    def register_check(check : Consul::Check)
      Consul::Util.put(client, "/v1/agent/check/register", data: check.to_json)
    end

    # deregister_check remove a check from the local agent. The agent will take care of deregistering the check from 
    # the catalog. If the check with the provided ID does not exist, no action is taken
    def deregister_check()
    end

    # ttl_check_pass is used with a TTL type check to set the status of the check to passing and to reset the TTL clock
    def ttl_check_pass(check_id : String, note : String? = nil)
      Consul::Util.put(client, "/v1/agent/check/pass/#{check_id}")
    end

    # ttl_check_warn is used with a TTL type check to set the status of the check to warning and to reset the TTL clock
    def ttl_check_warn(check_id : String, note : String? = nil)
      Consul::Util.put(client, "/v1/agent/check/warn/#{check_id}")
    end

    # ttl_check_fail is used with a TTL type check to set the status of the check to critical and to reset the TTL clock
    def ttl_check_fail(check_id : String, note : String? = nil)
      Consul::Util.put(client, "/v1/agent/check/fail/#{check_id}")
    end

    # ttl_check_upate is used with a TTL type check to set the status of the check and to reset the TTL clock
    def ttl_check_update(check_id : String, status : String? = nil, output : String? = nil)
      data = Hash(String, String)

      unless status.nil?
        data["Status"] = status
      end

      unless output.nil?
        data["Output"] = output
      end

      if data.empty?
        Consul::Util.put(client, "/v1/agent/check/update/#{check_id}")
      else
        Consul::Util.put(client, "/v1/agent/check/update/#{check_id}", data: data.to_json)
      end
    end

  end
end
