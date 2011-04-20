Bundler.setup :default, :test

require "nephophobia"

require "fakeweb"
require "minitest/spec"
require "nokogiri"
require "vcr"

class MiniTest::Unit::TestCase
  def cassette_for cassette, interaction = 0
    c = VCR::Cassette.new(cassette).send :recorded_interactions

    Nokogiri::XML::Document.parse c[interaction].response.body
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
      when :user ; {
        :access_key => "beeb1bd0-c920-4352-b078-5f297a0899a0",
        :secret_key => "5bf3d424-bcf1-4684-8fb0-2aaec275f896"
      }
      when :admin ; {
        :access_key => "03982c2e-8e28-40b6-95e2-f2811383b4a2",
        :secret_key => "a523e209-64cf-4d7a-978e-7bf3d5d0ca7e"
      }
    end.merge(:host => "10.3.170.32", :project => "sandbox")

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
