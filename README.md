# Nephophobia

Lean Ruby bindings to EC2.  Hands back a Nokogiri::XML::Document.

## Why

Compatibility with [VCR](https://github.com/myronmarston/vcr) largely drove this effort.

## Usage

### Bundler

    gem "nephophobia"

## Examples
    CLIENT = Nephophobia::Client.new(
      :host       => "example.com",
      :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
      :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506",
      :project    => "production"
    )

### Returns information about instances that you own (DescribeInstances).

    Nephophobia::Compute.new(CLIENT).all

## Testing

Tests can run offline thanks to [VCR](https://github.com/myronmarston/vcr).

    $ bundle exec rake
