# frozen_string_literal: true

module Roro
  module Configurators
    class Validator

      def initialize(catalog = nil, structure = nil)
        @catalog   = catalog   || Roro::CLI.catalog_root
        @structure = structure || StructureBuilder.build
        @error     = Roro::CatalogError
        @permitted_extensions = %w[yml yaml]
        validate_catalog
      end

      def validate_catalog(catalog = nil)
        catalog ||= @catalog
        case
        when catalog_not_present?(catalog)
          @msg = 'Catalog not present'
        when catalog_is_story_file?(catalog)
          validate_story(catalog)
        when catalog_is_template?(catalog)
          return
        when catalog_is_empty?(catalog)
          @msg = 'Catalog cannot be an empty folder'
        else
          get_children(catalog).each { |child| validate_catalog(child) }
        end
        raise(@error, "#{@msg} in #{@catalog}") if @msg
      end

      def validate_story(s)
        @error = Roro::CatalogError
        case
        when story_is_dotfile?(s)
          return
        when story_has_unpermitted_extension?(s)
          @msg = 'Catalog has unpermitted extension'
        when story_is_empty?(s)
          @msg = 'Story file is empty'
        else
          validate_content_structure(read_yaml(s))
        end
      end

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
        !(@permitted_extensions + %w[keep gitkeep]).include?(file_extension(story))
      end

      def story_has_nil_value?(content)
        content&.values&.include?(nil)
      end
    end
  end
end
