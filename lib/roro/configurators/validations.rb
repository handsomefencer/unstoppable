module Roro
  module Configurators
    module Validations

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

      def validate_catalog(location)
        ## cases:
        # when children returns no folder(s) or files
        #   [location] is an empty directory with no story. You may either remove
        #    the [location] or write a story to put in it.
        # when children returns a child with an unpermitted extension
        #   error: [child] with unpermitted [extension] extension in [location].
        #   Permitted extensions include [permitted_extensions.lastsplit]
        # ed extensions include [permitted_extensions]
        # when children returns only a templates folder
        #   error: template folder must have a story yaml file collocated
        # when children returns a yml file with filename matching location folder name
        #
        children = get_children(location)
        extensions = %w(keep yaml yml)
        extension = -> (file) { file.split('.').last }
        invalid = ->   (file) { extensions.include?(extension.call(file)) }
        filename = location.split('/').last.split('.')
        is_file = filename.size.eql?(2)
        is_directory = filename.size.eql?(1)
        case
        when is_file && !extensions.include?(filename.last)
          msg = "#{children} contains invalid extensions. Extensions must be in #{extensions.map { |e| ".#{e}"}}"
          raise Roro::Story::Empty, msg
        when is_directory && children.empty?
                  msg = "No story in #{location}"
          raise Roro::Story::Empty, msg
        when is_directory
          children.each { |child| validate_catalog(child) }
        when !children.any? {|file| invalid.call(file) }
        end
      end

      def validate_not_empty(file)
        content = read_yaml(file)
        raise Roro::Story::Empty, "No content in #{file}" if !content
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

      def validate_story(file, story=nil)
        content = read_yaml(file)
        validate_not_empty(file)
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
