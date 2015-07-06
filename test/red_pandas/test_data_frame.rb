require_relative '../test_helper'

describe RedPandas::DataFrame do
  describe "#initialize" do
    it "raises an ArgumentError if the columns are uneven" do
      a = RedPandas::Series.new([1], type: :any)
      b = RedPandas::Series.new([2, 3], type: :any)
      -> { RedPandas::DataFrame.new(a: a, b: b) }.must_raise(ArgumentError)
    end
  end

  describe "#names" do
    it "returns the names in order" do
      a = RedPandas::Series.new([1], type: :any)
      b = RedPandas::Series.new([2], type: :any)
      data_frame = RedPandas::DataFrame.new(a: a, b: b)
      data_frame.names.must_equal [:a, :b]
    end

    it "returns an empty array for an empty data frame" do
      data_frame = RedPandas::DataFrame.new
      data_frame.names.must_equal []
    end
  end

  describe "#type_names" do
    it "returns the type names in order" do
      a = RedPandas::Series.new([1], type: :any)
      b = RedPandas::Series.new([2], type: :integer)
      data_frame = RedPandas::DataFrame.new(a: a, b: b)
      data_frame.type_names.must_equal [:any, :integer]
    end

    it "returns an empty array for an empty data frame" do
      data_frame = RedPandas::DataFrame.new
      data_frame.type_names.must_equal []
    end
  end

  describe "#shape" do
    it "returns the correct shape for nonzero dimensions" do
      a = RedPandas::Series.new([1, 2, 3], type: :any)
      b = RedPandas::Series.new([4, 5, 6], type: :any)
      data_frame = RedPandas::DataFrame.new(a: a, b: b)
      data_frame.shape.must_equal [3, 2]
    end

    it "returns [0, 0] for an empty data frame" do
      data_frame = RedPandas::DataFrame.new
      data_frame.shape.must_equal [0, 0]
    end

    it "still returns a non-empty width if there are no rows" do
      a = RedPandas::Series.new([], type: :any)
      data_frame = RedPandas::DataFrame.new(a: a)
      data_frame.shape.must_equal [0, 1]
    end
  end
end
