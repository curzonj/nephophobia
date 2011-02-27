Bundler.setup :default, :test

require "nephophobia"

require "fakeweb"
require "minitest/spec"
require "nokogiri"
require "timecop"
require "vcr"

class MiniTest::Unit::TestCase
  USER_CLIENT = Nephophobia::Client.new(
    :host       => "10.1.170.32",
    :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
    :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506",
    :project    => "production"
  )

  ADMIN_CLIENT = Nephophobia::Client.new(
    :host       => "10.1.170.32",
    :access_key => "1d7a687b-0065-44d6-9611-5bf6c6c72424",
    :secret_key => "fd3053fd-25c2-48f8-b893-9f22661ec63c",
    :project    => "production",
    :path       => "/services/Admin/"
  )

  def cassette_for cassette
    c = VCR::Cassette.new(cassette).send :recorded_interactions

    Nokogiri::XML::Document.parse c.first.response.body
  end
end

VCR.config do |c|
  c.stub_with :fakeweb
  c.cassette_library_dir     = "test/fixtures/cassettes"
  c.default_cassette_options = { :record => :new_episodes }
end

Timecop.freeze Time.local 1999, 12, 31, 11, 59, 59
MiniTest::Unit.autorun
