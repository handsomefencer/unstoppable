# frozen_string_literal: true

module Roro
  module Configurators
    module Validations
      def catalog_is_story_file?
        File.file?(@catalog) && @permitted_extensions.include?(@extension)
      end

      def catalog_not_present?
        !File.exist?(@catalog)
      end

      def catalog_has_invalid_extension?
        @extension = @catalog.split('.').last
        @permitted_extensions = %w[yml yaml]
        !(@permitted_extensions + %w[keep gitkeep]).include?(@extension)
      end

      def validate_content_presence
        @msg = 'Story file is empty' if !@content || @content.empty?
      end

      def validate_content_classes(content, story)
        case
        when content.class != story.class
          @msg = "'#{content}' must be an instance of #{story.class}"
        when content.is_a?(Hash)
          content.each do |key, value|
            validate_content_classes(value, story[key])
          end
        when content.is_a?(Array)
          content.each do |item|
            validate_content_classes(item, story[0])
          end
        end
      end

      def validate_story(*args)
        @content = read_yaml(@catalog)
        validate_content_presence
        content = args.empty? ? @content : @content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        validate_content_classes(content, story)
        unpermitted_keys = content.keys - story.keys
        if content.is_a?(Hash)
          if unpermitted_keys.any?
            @msg = "Unpermitted keys #{unpermitted_keys} in #{content}"
          end

          content.each do |key, value|
            if value.nil?
              @msg = "Value for :#{key} must not be nil"
            elsif value.class != story[key].class
              @msg = "'#{value}' must be an instance of #{story[key].class}"
            elsif value.is_a?(Array)
              value.each do |_i|
                validate_story(*args, key, 0)
              end
            end
          end
        end
      end

      def validate_catalog(catalog)
        @catalog = catalog
        @error = Error
        case
        when catalog_not_present?
          @msg = 'Catalog not present'
        when catalog_has_invalid_extension?
          @msg = 'Catalog has invalid extension'
        when catalog_is_story_file?
          validate_story
        else
          return
        end
        raise @error, "#{@msg} in #{catalog}" if @msg
      end

      def validate_key_klass(content, story)
        msg = "\"#{content}\" class must be #{story.class}, not #{content.class}"
        raise(Error, msg) unless content.instance_of?(story.class)
      end

      def validate_story_content(*args)

        content = args.shift
        content = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        # validate_key_klass(content, story)
        case content
        when NilClass
          msg = "#{args.first} value is nil."
          raise Roro::Catalog::ContentError, msg
        when String
          nil
        when Array
          content.each do |_item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          content.each do |key, _value|
            args << key
            validate_story_content(content, *args)
          end
          raise Roro::Catalog::Keys if (content.keys - story.keys).any?
        end
      end

      def has_unpermitted_keys?(*args)
        content = args.shift
        content = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        validate_key_klass(content, story)
        content
        case content
        when NilClass
          msg = "#{args.first} value is nil."
          nil
        when String
          nil
        when Array
          content.each do |_item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          content.each do |key, _value|
            args << key
            has_unpermitted_keys?(content, *args)
          end
          raise Roro::Catalog::Keys if (content.keys - story.keys).any?
        end
      end

      def validate_keys(content, *args)
        content = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        return unless content

        unpermitted = content.keys - story.keys
        msg = "#{unpermitted} #{args.first} key must be in #{story.keys}"
        raise Roro::Story::Keys, msg if unpermitted.any?
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

      def raise_value_error(value, klass)
        msg = "#{value} class must be #{klass}, not #{value.class}"
        raise Roro::Story::Keys, msg
      end
    end
  end
end
