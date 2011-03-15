Bundler.setup :default, :test

require "nephophobia"

require "fakeweb"
require "minitest/spec"
require "nokogiri"
require "vcr"

class MiniTest::Unit::TestCase
  def cassette_for cassette
    c = VCR::Cassette.new(cassette).send :recorded_interactions

    Nokogiri::XML::Document.parse c.first.response.body
  end
end

VCR.config do |c|
  c.stub_with :fakeweb
  c.cassette_library_dir     = "test/cassettes"
  c.default_cassette_options = { :record => :none }
end

class Client
  def self.with type, options = {}
    client_options = case type
      when :user
        {
          :host => "10.1.170.32",
          :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
          :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506"
        }
      when :admin
        {
          :host => "10.1.170.32",
          :access_key => "1d7a687b-0065-44d6-9611-5bf6c6c72424",
          :secret_key => "fd3053fd-25c2-48f8-b893-9f22661ec63c"
        }
    end.merge(:project => "production")

    Nephophobia::Client.new client_options.merge options
  end
end

class Time
  class << self
    alias_method :real_now, :now
    def now
      Time.utc 1999, 12, 31, 19, 59, 59
    end
  end
end

MiniTest::Unit.autorun
