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

      def story_content_missing?
        !@content || @content.empty?
      end

      def validate_story_file(*args)
        object = args.empty? ? @content : @content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        if story_content_missing?
          @error = Error
          @msg = 'Story file is empty'
        elsif object.nil?
          @error = Error
          @msg = "#{@content.keys.first} must not be nil"
        elsif object.class != story.class
          @error = Error
          @msg = "'#{object}' must be a #{story.class}"
        elsif object.is_a?(Hash)
          object.each do |key, _value|
            args << key
            validate_story_file(*args)
          end
        end
      end

      def validate_catalog(catalog)
        @catalog = catalog
        case
        when catalog_not_present?
          @error = Error
          @msg = 'Catalog not present'
        when catalog_has_invalid_extension?
          @error = Error
          @msg = 'Catalog has invalid extension'
        when catalog_is_story_file?
          @content = read_yaml(@catalog)
          validate_story_file
        else
          return
        end
        raise @error, "#{@msg} in #{catalog}" if @error
      end

      def validate_key_klass(object, story)
        msg = "\"#{object}\" class must be #{story.class}, not #{object.class}"
        raise(Error, msg) unless object.instance_of?(story.class)
      end

      def validate_story_content(*args)
        content = args.shift
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        # validate_key_klass(object, story)
        case object
        when NilClass
          msg = "#{args.first} value is nil."
          raise Roro::Catalog::ContentError, msg
        when String
          nil
        when Array
          object.each do |_item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          object.each do |key, _value|
            args << key
            validate_story_content(content, *args)
          end
          raise Roro::Catalog::Keys if (object.keys - story.keys).any?
        end
      end

      # validate_file file, [:env, :base]
      # validate_file file, [:questions, 0]
      # validate_keys content
      # validate_keys content, :env
      # validate_keys content, :questions, 0
      def has_unpermitted_keys?(*args)
        content = args.shift
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        validate_key_klass(object, story)
        object
        case object
        when NilClass
          msg = "#{args.first} value is nil."
          nil
        when String
          nil
        when Array
          object.each do |_item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          object.each do |key, _value|
            args << key
            has_unpermitted_keys?(content, *args)
          end
          raise Roro::Catalog::Keys if (object.keys - story.keys).any?
        end
      end

      def validate_keys(content, *args)
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        return unless object

        unpermitted = object.keys - story.keys
        msg = "#{unpermitted} #{args.first} key must be in #{story.keys}"
        raise Roro::Story::Keys, msg if unpermitted.any?
      end

      def validate_file(*args)
        file = args.shift
        content = read_yaml(file)
        validate_not_empty(file)
        args.each do |*arg|
          klass = @story.dig(*arg.flatten).class
          klasses = [String, Array, Hash].reject { |k| k.eql?(klass) }
          object = content.dig(*arg.flatten)
          raise_value_error(object, klass) if klasses.include?(object.class)
        end
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
