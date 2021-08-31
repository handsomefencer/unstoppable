module Roro
  module Configurators
    module Validations

      def validate_catalog(catalog)
        @catalog = catalog
        case
        when !File.exist?(catalog)
          @error = Error
          @msg = 'Nothing exists'
        when File.file?(catalog)
          validate_story_file(read_yaml(@catalog))
        end
        raise @error, "#{@msg} in #{catalog}" if @error
      end

      def validate_story_file(*args)
        content = args.shift
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        case
        when invalid_story_file_extension?
          @msg = 'Story file has invalid extension'
        when %w(keep gitkeep).include?(@catalog.split('.').last)
          return
        when !content
          @msg = 'Story file is empty'
        when object.class != story.class
          @msg = "'#{object.to_s}' must be a #{story.class.to_s}"
        else
          return
        end
        @error = Error

      end

      def invalid_story_file_extension?
        !%w(yml yaml keep gitkeep).include?(@catalog.split('.').last)
      end

      def validate_story_content(content)
        !content || content.empty?
      end

      def validate_key_klass(object, story)
        msg = "\"#{object.to_s}\" class must be #{story.class.to_s}, not #{object.class.to_s}"
        raise(Error, msg) unless object.class.eql?(story.class)
      end

      def validate_story_content(*args)
        content = args.shift
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        # validate_key_klass(object, story)
        case
        when object.is_a?(NilClass)
          msg = "#{args.first} value is nil."
          raise Roro::Catalog::ContentError, msg
        when object.is_a?(String)
          return
        when object.is_a?(Array)
          object.each do |item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          object.each do |key, value|
            args << key
            validate_story_content(content, *args)
          end
          if (object.keys - story.keys).any?
            raise Roro::Catalog::Keys
          end
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
        case
        when object.is_a?(NilClass)
          msg = "#{args.first} value is nil."
          return
        when object.is_a?(String)
          return
        when object.is_a?(Array)
          object.each do |item|
            args << 0
            has_unpermitted_keys?(content, *args)
          end
        else
          object.each do |key, value|
            args << key
            has_unpermitted_keys?(content, *args)
          end
          if (object.keys - story.keys).any?
            raise Roro::Catalog::Keys
          end
        end
      end

      def validate_keys(content, *args)
        object = args.empty? ? content : content.dig(*args)
        story  = args.empty? ? @story : @story.dig(*args)
        return if !object
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
          klasses = [String, Array, Hash].reject {|k| k.eql?(klass) }
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
        array[1] ? "#{array[0..-2].join(", ")} and #{array[-1]}" : array[0]
      end

      def raise_value_error(value, klass)
        msg = "#{value} class must be #{klass}, not #{value.class.to_s}"
        raise Roro::Story::Keys, msg
      end
    end
  end
end
