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
        case
        when !content
          @msg = 'Story file is empty'
        when content.is_a?(NilClass)
          @msg = 'Story contains a nil value'
        when !content.is_a?(structure.class)
          @msg = "'#{content}' must be an instance of #{structure.class}"
        when content.is_a?(Array)
          validate_content_array(content, structure)
        when content.is_a?(Hash)
          validate_content_hash(content, structure)
        end
      end

      # def validate_story(s)
      #   @error = Roro::CatalogError
      #   case
      #   when stack_is_dotfile?(s)
      #     return
      #   when story_has_unpermitted_extension?(s)
      #     @msg = 'Catalog has unpermitted extension'
      #   when story_is_empty?(s)
      #     @msg = 'Story file is empty'
      #   # else
      #   #   validate_content_structure(read_yaml(s))
      #   end
      # end
        def validate_content_structure(content, structure = @structure)
          case
          when content.is_a?(NilClass)
            @msg = 'Story contains a nil value'
          when !content.is_a?(structure.class)
            @msg = "'#{content}' must be an instance of #{structure.class}"
          when content.is_a?(Array)
            validate_content_array(content, structure)
          when content.is_a?(Hash)
            validate_content_hash(content, structure)
          end
        end



      # def validate_stack(catalog = nil)
      #   catalog ||= @catalog
      #   @stack_root ||= catalog
      #   case
      #   when stack_not_present?(catalog)
      #     @msg = 'Catalog not present'
      #   when stack_is_storyfile?(catalog)
      #     validate_story(catalog)
      #   when stack_is_templates?(catalog)
      #     return
      #   when stack_type(catalog).eql?(:empty)
      #     @msg = 'Catalog cannot be an empty folder'
      #   else
      #     get_children(catalog).each { |child| validate_stack(child) }
      #   end
      #   raise(@error, "#{@msg} in #{catalog}") if @msg
      # end



      # def validate_story(s)
      #   @error = Roro::CatalogError
      #   case
      #   when stack_is_dotfile?(s)
      #     return
      #   when story_has_unpermitted_extension?(s)
      #     @msg = 'Catalog has unpermitted extension'
      #   when story_is_empty?(s)
      #     @msg = 'Story file is empty'
      #   else
      #     validate_content_structure(read_yaml(s))
      #   end
      # end

      def validate_content_structure(content, structure = @structure)
        case
        when content.is_a?(NilClass)
          @msg = 'Story contains a nil value'
        when !content.is_a?(structure.class)
          @msg = "'#{content}' must be an instance of #{structure.class}"
        when content.is_a?(Array)
          validate_content_array(content, structure)
        when content.is_a?(Hash)
          validate_content_hash(content, structure)
        end
      end

      def validate_content_array(content, structure)
        if content.any?(nil)
          @msg = 'Story contains an empty array'
        else
          content.each { |item| validate_content_structure(item, structure[0]) }
        end
      end

      def validate_content_hash(content, structure)
        case
        when story_has_unpermitted_keys?(content, structure)
          @msg = "#{@unpermitted} not in permitted keys: #{@permitted}"
        when story_has_nil_value?(content)
          @msg = "Value for :#{content.key(nil)} must not be nil"
        when structure&.keys&.any?
          content.each { |k, v| validate_content_structure(v, structure[k]) }
        end
      end

      def story_has_unpermitted_keys?(content, structure)
        @permitted = structure&.keys
        @unpermitted = content.keys - @permitted
        @permitted.any? && @unpermitted.any?
      end

      def story_has_unpermitted_extension?(story)
        !(@ext_permitted).include?(file_extension(story))
      end

      def story_has_nil_value?(content)
        content&.values&.include?(nil)
      end
    end
  end
end
