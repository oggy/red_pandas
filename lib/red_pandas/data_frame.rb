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

    def [](column_names)
      if column_names.respond_to?(:to_ary)
        column_names.map { |c| @data[column_index(c)] }
      else
        @data[column_index(column_names)]
      end
    end

    def column(name)
      index = @data.index(name.to_sym) and
        @data[index]
    end

    private

    def column_index(column_name)
      @names.index(column_name.to_sym) or
        raise ArgumentError, "invalid colume name: #{column_name}"
    end
  end
end
