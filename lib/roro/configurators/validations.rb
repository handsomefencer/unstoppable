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
        children = get_children(location)
        extensions = %w(keep yaml yml)
        extension = -> (file) { file.split('.').last }
        invalid = ->   (file) { extensions.include?(extension.call(file)) }
        case
        when children.empty?
          msg = "No story in #{location}"
          raise Roro::Story::Empty, msg
        when !children.any? {|file| invalid.call(file) }
          msg = "#{children} contains invalid extensions. Extensions must be in #{extensions.map { |e| ".#{e}"}}"
          raise Roro::Story::Empty, msg
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

      def validate_content(content, *args)
        klass = @story.dig(*args).class.to_s
        klasses = [String, Array, Hash].map(&:to_s)
        klasses.delete(klass)
        object = content.dig(*args)
        raise_value_error(object, klass) if klasses.include?(object.class.to_s)
      end

      def validate_story(file)
        content = read_yaml(file)
        validate_not_empty(file)
        validate_content content, :preface
        validate_content content, :actions
        validate_content content, :env
        validate_content content, :env, :base
        validate_content content, :questions
        validate_content content, :questions, 0
        validate_keys content
        validate_keys content, :env
        validate_keys content, :questions, 0
      end

      def raise_value_error(value, klass)
        msg = "#{value} class must be #{klass}, not #{value.class.to_s}"
        raise Roro::Story::Keys, msg
      end
    end
  end
end
