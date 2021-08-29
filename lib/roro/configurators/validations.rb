module Roro
  module Configurators
    module Validations

      def validate_file_extension(file)
        %w(yml yaml).include?(file.split('.').last) ? false : true
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

      def validate_catalog(location)
        @location = location
        case
        when File.file?(location)
          validate_story_content(location)
        end
      end

      def validate_story(file, story=nil)
        @content = read_yaml(file)
        case
        when has_invalid_extension?(file)
          raise Error
        when has_no_content?
          raise Error
        when has_unpermitted_keys?(content)
          raise Error
        when has_invalid_key_klass?(content)
          raise Error
        end
        story ||= @story
        content.each do |key, value|
          story_keys = story.keys
          msg = "#{key} key must be in #{story.keys}"
          raise Roro::Story::Keys, msg unless story_keys.include?(key)
          next if story[key].nil?
          msg = "#{value} class must be #{story[key].class}, not #{value.class.to_s}"
          raise Roro::Story::Keys, msg unless story[key].class.eql?(value.class)
        end
        # validate_file file, :actions, :env, :preface, :questions
        validate_file file, [:env, :base]
        validate_file file, [:questions, 0]
        validate_keys content
        validate_keys content, :env
        validate_keys content, :questions, 0
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
