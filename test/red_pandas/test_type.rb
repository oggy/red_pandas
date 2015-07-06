require_relative '../test_helper'

describe RedPandas::Type do
  describe RedPandas::Type::Any do
    describe ".cast" do
      it "returns the raw value" do
        object = Object.new
        RedPandas::Type::Any.cast(object).must_equal object
      end
    end
  end

  describe RedPandas::Type::String do
    describe ".cast" do
      it "casts the value to a string" do
        RedPandas::Type::String.cast(1).must_equal '1'
      end
    end
  end

  describe RedPandas::Type::Integer do
    describe ".cast" do
      it "casts the value to a integer" do
        RedPandas::Type::Integer.cast('1').must_be_same_as 1
      end
    end
  end

  describe RedPandas::Type::Float do
    describe ".cast" do
      it "casts the value to a float" do
        RedPandas::Type::Float.cast('1').must_be_same_as 1.0
      end
    end
  end
end
