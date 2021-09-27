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

      def validate(s)
        s ||= @stack
        @stack_root ||= s
        base_validate(s)
        case stack_type(s)
        when :storyfile
          validate_plot(read_yaml(s))
        end
        raise(@error, "#{@msg} in #{s}") if @msg
      end

      def validate_plot(content, structure = @structure)
        c = content
        s = structure
        case
        when !c
          @msg = 'Story file is empty'
        when c.is_a?(NilClass)
          @msg = 'Story contains a nil value'
        when !c.is_a?(s.class)
          @msg = "'#{c}' must be an instance of #{s.class}"
        when c.is_a?(Array) && c.any?(nil)
          @msg = 'Story contains an empty array'
        when c.is_a?(Array)
          c.each { |item| validate_plot(item, s[0]) }
        when c.is_a?(Hash) && story_has_unpermitted_keys?(c, s)
          @msg = "#{@unpermitted} not in permitted keys: #{@permitted}"
        when c.is_a?(Hash) && story_has_nil_value?(c)
          @msg = "Value for :#{c.key(nil)} must not be nil"
          else
          c.each { |k, v| validate_plot(v, structure[k]) }
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
