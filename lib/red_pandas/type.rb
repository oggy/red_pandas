module RedPandas
  module Type
    def self.lookup(specifier)
      return specifier if specifier.is_a?(Module)
      types[specifier]
    end

    def self.register(mod)
      types[mod.type_name] = mod
    end

    def self.types
      @types ||= {}
    end

    module Any
      def self.type_name
        :any
      end

      def self.cast(value)
        value
      end

      Type.register self
    end

    module String
      def self.type_name
        :string
      end

      def self.cast(value)
        value.to_s
      end

      Type.register self
    end

    module Integer
      def self.type_name
        :integer
      end

      def self.cast(value)
        value.to_i
      end

      Type.register self
    end

    module Float
      def self.type_name
        :float
      end

      def self.cast(value)
        value.to_f
      end

      Type.register self
    end
  end
end
