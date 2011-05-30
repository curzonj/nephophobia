require "test_helper"

describe Nephophobia::Util do
  describe "::coerce" do
    it "wraps a Hash with an Array" do
      hash = { :foo => :bar }

      Nephophobia::Util.coerce(hash).must_equal [hash]
    end

    it "doesn't wrap others" do
      array = [:foo, :bar]

      Nephophobia::Util.coerce(array).must_equal array
    end
  end
end
