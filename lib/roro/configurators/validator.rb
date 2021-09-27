# frozen_string_literal: true

module Roro
  module Configurators
    class Validator

      attr_reader :stack, :structure, :ext_hidden, :ext_story, :ext_permitted

      def initialize(catalog = nil, structure = nil)
        @catalog       = catalog   || Roro::CLI.catalog_root
        @stack         = catalog   || Roro::CLI.catalog_root
        @structure     = structure || StructureBuilder.build
        @error         = Roro::CatalogError
        @ext_story     = %w[yml yaml]
        @ext_hidden    = %w[.keep .gitkeep]
        @ext_permitted = @ext_story + @ext_hidden
      end

      def base_validate(s)
        case
        when stack_is_nil?(s)
          @msg = 'Catalog not present'
        when stack_is_empty?(s)
          @msg = 'Catalog cannot be an empty folder'
        when stack_unpermitted?(s)
          @msg = 'Catalog has unpermitted extension'
        end
      end

      def validate(stack)
        stack ||= @stack
        @stack_root ||= stack
        base_validate(stack)
        case stack_type(stack)
        when :storyfile
          validate_plot(read_yaml(stack))
        end
        raise(@error, "#{@msg} in #{stack}") if @msg
      end

      def validate_plot(plot, structure = @structure)
        case status(plot, structure)
        when :plot_empty
          @msg = 'Story file is empty'
        when :unexpected_class
          @msg = "'#{plot}' must be an instance of #{structure.class}"
        when :array_empty
          @msg = 'Story contains an empty array'
        when :unpermitted_keys
          @msg = "#{@unpermitted} not in permitted keys: #{@permitted}"
        when :hash_value_nil
          @msg = "Value for :#{plot.key(nil)} must not be nil"
        when :array_valid
          plot.each { |item| validate_plot(item, structure[0]) }
        when :hash_expecting_values
          plot.each { |k, v| validate_plot(v, structure[k]) }
        end
      end

      def status(c, s)
        case
        when !c
          :plot_empty
        when !c.is_a?(s.class)
          :unexpected_class
        when c.is_a?(Array) && c.any?(nil)
          :array_empty
        when c.is_a?(Hash) && story_has_unpermitted_keys?(c, s)
          :unpermitted_keys
        when c.is_a?(Hash) && story_has_nil_value?(c)
          :hash_value_nil
        when c.is_a?(Hash) && s.keys&.any?
          :hash_expecting_values
        when c.is_a?(Array)
          :array_valid
        end
      end

      def story_has_unpermitted_keys?(content, structure)
        @permitted = structure&.keys
        @unpermitted = content.keys - @permitted
        @permitted.any? && @unpermitted.any?
      end

      def story_has_nil_value?(content)
        content&.values&.include?(nil)
      end
    end
  end
end
