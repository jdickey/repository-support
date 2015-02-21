
# Support classes for Repository::Base and subclasses.
module Repository
  # Support classes for Repository::Base and subclasses.
  module Support
    # Adds :attributes property to caller, and enhanced attribute getter/setter.
    module TestAttributeContainer
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      def init_empty_attribute_container
        define_method :attributes do
          @attributes ||= {}
        end

        define_method(:attributes=) do |attribs|
          @attributes = attribs.to_h
        end

        define_method(:method_missing) do |method_sym, *arguments, &block|
          method_or_type = attribute_key_for?(method_sym)
          case method_or_type
          when :none
            super method_sym, arguments, block
          when :reader
            attributes[method_sym]
          else
            attributes[method_or_type] = arguments.first
          end
        end

        define_method(:respond_to?) do |method_sym, include_private = false|
          return true unless attribute_key_for?(method_sym) == :none
          super method_sym, include_private
        end

        # private
        define_method(:attribute_key_for?) do |key_sym|
          if attributes.to_h.key? key_sym
            :reader
          else
            setter_for_or_none(key_sym)
          end
        end

        # private
        define_method :setter_for_or_none do |key|
          match = key.to_s.match(/(\S+?)=/)
          has_setter = match && attributes.key?(match[1].to_sym)
          has_setter ? match[1].to_sym : :none
        end
        instance_eval { private :attribute_key_for?, :setter_for_or_none }
        self
      end # end method .init_empty_attribute_container
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/AbcSize
      self
    end # module Repository::Support::TestAttributeContainer
  end
end
