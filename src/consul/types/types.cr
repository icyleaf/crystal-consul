require "json"

module Consul
  module Types

    module KV
      class KV
        JSON.mapping(
          key:    {type: String, key: "Key"},
          value:  {type: String, key: "Value"},
        )
      end
      struct KvPair
        getter key, value

        def initialize(@key : String, @value : String)
        end
      end
    end

    module Catalog
      class Node
        JSON.mapping(
          id:               {type: String, key: "ID"},
          node:             {type: String, key: "Node"},
          address:          {type: String, key: "Address"},
          datacenter:       {type: String, key: "Datacenter"},
          tagged_addresses: {type: Hash(String, String), key: "TaggedAddresses", nilable: true},
          meta:             {type: Hash(String, String), key: "Meta", nilable: true}
        )
      end

      class NodeService
        JSON.mapping(
          id:               {type: String, key: "ID"},
          node:             {type: String, key: "Node"},
          address:          {type: String, key: "Address"},
          datacenter:       {type: String, key: "Datacenter"},
          tagged_addresses: {type: Hash(String, String), key: "TaggedAddresses", nilable: true},
          node_meta:        {type: Hash(String, String), key: "NodeMeta", nilable: true},
          service_id:       {type: String, key: "ServiceID"},
          service_name:     {type: String, key: "ServiceName"},
          service_tags:     {type: Array(String), key: "ServiceTags", nilable: true},
          service_address:  {type: String, key: "ServiceAddress"},
          service_meta:     {type: Hash(String, String), key: "ServiceMeta"},
          service_port:     {type: Int32, key: "ServicePort"},
        )
      end
    end

    module Agent
      class ServiceConf
        JSON.mapping(
          kind:                 {type: String, key: "Kind", nilable: true},
          id:                   {type: String, key: "ID"},
          service:              {type: String, key: "Service"},
          tags:                 {type: Array(String), key: "Tags", nilable: true},
          meta:                 {type: Hash(String, String), key: "Meta", nilable: true},
          address:              {type: String, key: "Address"},
          port:                 {type: Int32, key: "Port"},
          enable_tag_override:  {type: Bool, key: "EnableTagOverride"},
          content_hash:         {type: String, key: "ContentHash"}
        )
      end

      class Service
        JSON.mapping(
          id:       {type: String, key: "ID"},
          service:  {type: String, key: "Service"},
          tags:     {type: Array(String), key: "Tags"},
          port:     {type: Int32, key: "Port"},
          address:  {type: String, key: "Address"}
        )
      end

      class Check 
        JSON.mapping(
          node:     {type: String, key: "Node"},
          check_id: {type: String, key: "CheckID"},
          name:     {type: String, key: "Name"},
          status:   {type: String, key: "Status"},
          output:   {type: String, key: "Output"}
        )
      end

      class ServiceHealth
        JSON.mapping(
          aggregated_status:  {type: String, key: "AggregatedStatus"},
          service:            {type: Service, key: "Service"},
          checks:             {type: Array(Check), key: "Checks"}
        )
      end
    end

  end
end