# frozen_string_literal: true

module Roro
  module Configurators
    module Validations

      def validate_catalog(catalog)
        @error = Error
        @catalog = catalog
        case
        when catalog_not_present?
          @msg = 'Catalog not present'
        when catalog_is_story_file?
          validate_story
        else
          validate_structure
        end
        raise(@error, @msg) if @msg
      end

      def catalog_not_present?
        !File.exist?(@catalog)
      end

      def catalog_is_story_file?
        File.file?(@catalog)
      end

      def validate_story(*args)
        @extension = @catalog.split('.').last
        @permitted_extensions = %w[yml yaml]
        case
        when story_is_dotfile?
          return
        when story_has_unpermitted_extension?
          @msg = 'Catalog has unpermitted extension'
        when story_is_empty?
          @msg = 'Story file is empty'
        else
          validate_story_content(@content, @story)
        end
      end

      def story_is_dotfile?
        %w[keep gitkeep].include?(@extension)
      end

      def story_has_unpermitted_extension?
        !(@permitted_extensions + %w[keep gitkeep]).include?(@extension)
      end

      def story_is_empty?
        content = read_yaml(@catalog)
        @content = content if content
        !content
      end

      def validate_story_content(content, story)
        case
        when content.is_a?(NilClass)
          @msg = 'Story contains a nil value'
        when !content.is_a?(story.class)
          @msg = "'#{content}' must be an instance of #{story.class}"
        when content.is_a?(Array)
          validate_story_array(content, story)
        when content.is_a?(Hash)
          validate_story_hash(content, story)
        end
      end

      def validate_story_array(content, story)
        if content.any?(nil)
          @msg = 'Story contains an empty array'
        else
          content.each { |item| validate_story_content(item, story[0]) }
        end
      end

      def validate_story_hash(content, story)
        case
        when story_has_unpermitted_keys?(content, story)
          @msg = "#{content.keys} not in permitted keys: #{story.keys}"
        when story_has_nil_value?(content)
          @msg = "Value for :#{content.key(nil)} must not be nil"
        when story&.keys&.any?
          content.each { |k, v| validate_story_content(v, story[k]) }
        end
      end

      def story_has_unpermitted_keys?(content, story)
        story&.keys.any? && (content.keys - story.keys).any?
      end

      def story_has_nil_value?(content)
        content&.values&.include?(nil)
      end

      def sanitize(options)
        (options ||= {}).transform_keys!(&:to_sym).each do |key, value|
          case value
          when Array
            value.each { |vs| sanitize(vs) }
          when Hash
            sanitize(value)
          when true
            options[key] = true
          when String || Symbol
            options[key] = value.to_sym
          end
        end
      end

      def sentence_from(array)
        array[1] ? "#{array[0..-2].join(', ')} and #{array[-1]}" : array[0]
      end
    end
  end
end
