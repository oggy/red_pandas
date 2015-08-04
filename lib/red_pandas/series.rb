module RedPandas
  class Series
    def initialize(data=[], type: Type::String)
      @type = Type.lookup(type)
      @data = data.map { |value| @type.cast(value) }
    end

    attr_reader :type, :data

    def type_name
      type.type_name
    end

    def [](arg)
      @data[arg]
    end

    def size
      @data.size
    end

    def select_by_position(selector)
      case selector
      when Range
        data = @data[selector]
        self.class.new(data, type: type)
      when Enumerable
        data = selector.map { |index| @data[index] }
        self.class.new(data, type: type)
      else
        @data[selector]
      end
    end
  end
end
