# frozen_string_literal: true

module Roro
  module Configurators

    class Validator
      include Utilities

      attr_reader :stack, :structure, :permitted_hidden_extensions, :permitted_story_extensions, :ext_permitted

      def initialize(stack = nil, structure = nil)
        @stack         = stack     || Roro::CLI.catalog_root
        @structure     = structure || StructureBuilder.build
        @error         = Roro::CatalogError
        @permitted_story_extensions  = %w[yml yaml]
        @permitted_hidden_extensions = %w[.keep .gitkeep]
        @permitted_extensions        = @permitted_story_extensions +
                                       @permitted_hidden_extensions
      end

      ## TODO: validate ambiguous
      # Add validation to ensure story directory has either a) a matching storyfile or b)
      # at least one child stack, story, or inflection.

      def base_validate(s)
        case
        when stack_is_nil?(s)
          @msg = 'Catalog not present'
        when stack_is_ignored?(s)
          return
        when stack_is_empty?(s)
          @msg = 'Catalog cannot be an empty folder'
        when stack_unpermitted?(s)
          @msg = 'Catalog has unpermitted extension'
        when stack_unrecognized?(s)
          @msg = 'Catalog must be a story, a stack, or an inflection'
        end
      end

      def stack_unrecognized?(stack)
        stack_type(stack).nil?
      end

      def validate(stack = nil)
        stack ||= @stack
        @stack_root ||= stack
        base_validate(stack)
        case stack_type(stack)
        when :storyfile
          validate_plot(read_yaml(stack))
        when :story
          children(stack).each { |c| validate(c) }
        when :inflection
          children(stack).each { |c| validate(c) }
        when :stack
          children(stack).each { |c| validate(c) }
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

      def status(plot, structure)
        case
        when !plot
          :plot_empty
        when !plot.is_a?(structure.class)
          :unexpected_class
        when plot.is_a?(Array) && plot.any?(nil)
          :array_empty
        when plot.is_a?(Hash) && story_has_unpermitted_keys?(plot, structure)
          :unpermitted_keys
        when plot.is_a?(Hash) && story_has_nil_value?(plot)
          :hash_value_nil
        when plot.is_a?(Hash) && structure.keys&.any?
          :hash_expecting_values
        when plot.is_a?(Array)
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
