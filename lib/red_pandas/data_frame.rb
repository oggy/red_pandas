module RedPandas
  class DataFrame
    def initialize(columns={})
      @names = columns.keys.map(&:to_sym)
      @data = columns.values

      unless @data.empty?
        @data.map(&:size).uniq.size == 1 or
          raise ArgumentError, "columns uneven"
      end
    end

    def names
      @names.dup
    end

    def type_names
      @data.map { |series| series.type.type_name }
    end

    def shape
      if @data.empty?
        [0, 0]
      else
        [@data[0].size, @data.size]
      end
    end
  end
end
