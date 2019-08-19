# 💎 crystal-consul

[![Language](https://img.shields.io/badge/language-crystal-776791.svg)](https://github.com/crystal-lang/crystal)
[![Build Status](https://travis-ci.org/rogerwelin/crystal-consul.svg?branch=master)](https://travis-ci.org/rogerwelin/crystal-consul)

TODO: Write a description here

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crystal-consul:
       github: rogerwelin/crystal-consul
   ```

2. Run `shards install`

## Example Usage

```crystal
require "consul"

# create a default client
c = Consul.client()

# create a key
c.kv.create_key("stage/my_app", "version: 1")

# read key
key = c.kv.get_key("stage/my_app")

# you can also get keys recursively
key = c.kv.get_key("stage", recurse: true)

# register a service on the local agent
service = Consul::Service.new()
service.serice = "service-example"
service.tags = ["master"]
service.port = 9922

c.agent.register_service(service)

```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/rogerwelin/crystal-consul/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roger Welin](https://github.com/rogerwelin) - creator and maintainer
