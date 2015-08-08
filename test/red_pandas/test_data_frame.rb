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

  describe "#empty?" do
    it "is true if there are no columns" do
      frame = RedPandas::DataFrame.new
      frame.empty?.must_equal true
    end

    it "is true if there are columns but they're all empty" do
      frame = RedPandas::DataFrame.new(a: [])
      frame.empty?.must_equal true
    end

    it "is false otherwise" do
      frame = RedPandas::DataFrame.new(a: [nil])
      frame.empty?.must_equal false
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

  describe "#[]" do
    it "returns a single column" do
      a = RedPandas::Series.new([1, 2], type: :any)
      b = RedPandas::Series.new([3, 4], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)
      series = frame[:a]
      series.must_be_instance_of(RedPandas::Series)
      series.must_equal a
    end

    it "accepts a string for the column" do
      a = RedPandas::Series.new([1, 2], type: :any)
      b = RedPandas::Series.new([3, 4], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)
      series = frame['a']
      series.must_be_instance_of(RedPandas::Series)
      series.must_equal a
    end

    it "returns multiple columns" do
      a = RedPandas::Series.new([1, 2], type: :any)
      b = RedPandas::Series.new([3, 4], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)
      series = frame[[:a, :b]]
      series.map(&:class).must_equal [RedPandas::Series]*2
      series.must_equal [a, b]
    end

    it "accepts strings for columns" do
      a = RedPandas::Series.new([1, 2], type: :any)
      b = RedPandas::Series.new([3, 4], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)
      series = frame[['a', 'b']]
      series.map(&:class).must_equal [RedPandas::Series]*2
      series.must_equal [a, b]
    end
  end

  describe "#select_by_position" do
    it "supports selecting a row by integer" do
      a = RedPandas::Series.new([1, 2], type: :any)
      b = RedPandas::Series.new([3, 4], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)

      row = frame.select_by_position(1)
      row.must_be_instance_of RedPandas::Series
      row.data.must_equal [2, 4]
    end

    it "supports selecting rows by array of integers" do
      a = RedPandas::Series.new([1, 2, 3], type: :any)
      b = RedPandas::Series.new([4, 5, 6], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)

      subframe = frame.select_by_position([0, 2])
      subframe.must_be_instance_of RedPandas::DataFrame
      subframe['a'].data.must_equal [1, 3]
      subframe['b'].data.must_equal [4, 6]
    end

    it "supports selecting rows by range" do
      a = RedPandas::Series.new([1, 2, 3], type: :any)
      b = RedPandas::Series.new([4, 5, 6], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)

      subframe = frame.select_by_position(1..2)
      subframe.must_be_instance_of RedPandas::DataFrame
      subframe['a'].data.must_equal [2, 3]
      subframe['b'].data.must_equal [5, 6]
    end
  end

  describe "#filter" do
    it "returns a DataFrame with rows that pass the given predicate" do
      a = RedPandas::Series.new([1, 2, 3], type: :any)
      b = RedPandas::Series.new([4, 5, 6], type: :any)
      frame = RedPandas::DataFrame.new(a: a, b: b)

      subframe = frame.filter { |row| row[:a] % 2 == 1 }
      subframe.must_be_instance_of RedPandas::DataFrame
      subframe['a'].data.must_equal [1, 3]
      subframe['b'].data.must_equal [4, 6]
    end

    it "raises ArgumentError if no block is given" do
      frame = RedPandas::DataFrame.new
      -> { frame.filter }.must_raise ArgumentError
    end
  end
end
