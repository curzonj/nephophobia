require "test_helper"

describe Nephophobia do
  describe "::to_eh" do
    it "wraps a Hash with an Array" do
      hash = { :foo => :bar }

      Nephophobia.to_eh(hash).must_equal [hash]
    end

    it "doesn't wrap others" do
      array = [:foo, :bar]

      Nephophobia.to_eh(array).must_equal array
    end
  end
end
