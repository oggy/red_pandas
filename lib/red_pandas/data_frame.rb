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

    def empty?
      @data.empty? || @data[0].empty?
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

    def select_by_position(selector)
      case selector
      when Range, Enumerable
        columns = {}
        @names.zip(@data) do |name, data|
          columns[name] = data.select_by_position(selector)
        end
        self.class.new(columns)
      else
        row = @data.map do |data|
          data.select_by_position(selector)
        end
        Series.new(row, type: :any)
      end
    end

    def filter
      block_given? or
        raise ArgumentError, "no block given"

      empty? and
        return DataFrame.new(@names.zip(@data).to_h)

      rows = []
      @data[0].size.times do |i|
        row_values = @data.map { |column| column[i] }
        row = @names.zip(row_values).to_h
        rows << row_values if yield(row)
      end

      columns = @data.zip(rows.transpose).map do |original_column, values|
        RedPandas::Series.new(values, type: original_column.type)
      end
      names_to_columns = @names.zip(columns).to_h
      DataFrame.new(names_to_columns)
    end

    private

    def column_index(column_name)
      @names.index(column_name.to_sym) or
        raise ArgumentError, "invalid colume name: #{column_name}"
    end

    def make_row(values)
      @names.zip(values).to_h
    end
  end
end
