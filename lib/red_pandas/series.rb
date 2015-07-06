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
  end
end
