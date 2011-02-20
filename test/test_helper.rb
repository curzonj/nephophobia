Bundler.setup :default, :test

require "nephophobia"

require "minitest/spec"
require "timecop"
require "vcr"
require "webmock"

class MiniTest::Unit::TestCase
  CLIENT = Nephophobia::Client.new(
    :host       => "10.1.170.32",
    :access_key => "9c01b833-3047-4f2e-bb2a-5c8dc7c8ae9c",
    :secret_key => "3ae9d9f0-2723-480a-99eb-776f05950506",
    :project    => "production"
  )

end

Timecop.travel Time.local 1999, 12, 31, 11, 59, 59

VCR.config do |c|
  c.stub_with :webmock
  c.cassette_library_dir     = "test/fixtures/cassettes"
  c.default_cassette_options = { :record => :none }
end

MiniTest::Unit.autorun
