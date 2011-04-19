# Nephophobia

Lean Ruby bindings to [EC2](http://aws.amazon.com/ec2/), and OpenStack's Admin endpoints.  Hands back an Object for access.

## Why

Compatibility with [VCR](https://github.com/myronmarston/vcr) largely drove this effort.

## Usage

### Bundler

    gem "nephophobia"

### Examples

See the examples section in the [wiki](http://github.com/retr0h/nephophobia/wiki).

## Compatability

ruby 1.9.2

## Testing

Tests can run offline thanks to [VCR](https://github.com/myronmarston/vcr).

    $ bundle exec rake

## TODO

* Cleanup test initializers once all tests use same API key.
