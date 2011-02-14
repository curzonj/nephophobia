Bundler.setup :default, :test

require "nephophobia"

require "minitest/spec"
#require "uri"
#require "webmock"

class MiniTest::Unit::TestCase
end

MiniTest::Unit.autorun
