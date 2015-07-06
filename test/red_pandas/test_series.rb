require_relative '../test_helper'

describe RedPandas::Series do
  describe "#type" do
    it "returns the type object" do
      series = RedPandas::Series.new([], type: :any)
      series.type.must_equal RedPandas::Type::Any
    end
  end

  describe "#type_name" do
    it "returns the type name" do
      series = RedPandas::Series.new([], type: :any)
      series.type_name.must_equal :any
    end
  end

  describe "#[]" do
    it "returns the value at the given index" do
      series = RedPandas::Series.new([1, 2], type: :any)
      series[0].must_equal 1
      series[1].must_equal 2
    end

    it "returns nil if the given index is out of bounds" do
      series = RedPandas::Series.new([1], type: :any)
      series[1].must_be_nil
    end
  end

  describe "#size" do
    it "returns the number of elements in the series" do
      series = RedPandas::Series.new([1, 2], type: :any)
      series.size.must_equal 2
    end
  end
end
