# Nephophobia

Lean Ruby bindings to OpenStack's AWS EC2 endpoint.  Hands back a Hash (for now).

## Why

Compatibility with [VCR](https://github.com/myronmarston/vcr) largely drove this effort.

## Usage

### Bundler

    gem "nephophobia"

### Examples

See the examples section in the [wiki](http://github.com/retr0h/nephophobia/wiki).

## Testing

Tests can run offline thanks to [VCR](https://github.com/myronmarston/vcr).

    $ bundle exec rake
