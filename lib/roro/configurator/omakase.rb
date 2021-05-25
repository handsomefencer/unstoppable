module Roro
  module Configurator
    module Omakase
      attr_reader :structure, :intentions, :env, :options, :story

      def initialize(args = {}, options = {})

        @options = sanitize(args)
        @structure = {
          intentions: {},
          choices: {},
          env_vars: {}
        }
        @story = @options[:story] ? { rollon: @options[:story] } : default_story
        build_story
        @intentions = @structure[:intentions]
        @env = @structure[:env_vars]
        @env[:main_app_name] = Dir.pwd.split('/').last
        @env[:ruby_version] = RUBY_VERSION
        @env[:force] = true
        @env[:verbose] = false
        @env[:roro_version] = VERSION
      end

      def build_story
        layer_greenfield
        layer_rollon
        layer_story
        layer_okonomi
      end

      def layer_okonomi
        return unless @options.keys.include?(:okonomi)

        @structure[:okonomi] = true
        take_order
      end

      def layer_greenfield
        return unless @options.keys.include?(:greenfield)

        @structure[:greenfield] = true
        build_layers( { greenfield: :rails } )
      end

      def layer_rollon
        build_layers(@story)
      end

      def layer_story
        file = '.roro_story'
        return unless File.exist?("#{file}.yml")

        overlay(get_layer(file))
      end

      def build_layers(story, location = nil)
        story = story.is_a?(Hash) ? story : { story => {}}
        story.each do |key, value|
          location = location ? "#{location}/#{key}" : key
          case value
          when Array
            value.each {|value| build_layers(value, location) }
          when true
          when
            build_layers(value, location)
          end
        end
        overlay(get_layer("#{Roro::CLI.story_root}/#{location}"))
      end

      def overlay(layer)
        layer.each do |key, value|
          @structure[key] ||= value
        end
        overlay_choices(layer) if layer[:choices]
        overlay_env_vars(layer) if layer[:env_vars]
        overlay_actions(layer) if layer[:actions]
      end

      def overlay_actions(layer)
        @structure[:actions].concat(layer[:actions])
      end

      def overlay_env_vars(layer)
        layer[:env_vars].each do |key, value|
          @structure[:env_vars][key] = value
        end
      end

      def overlay_choices(layer)
        @structure[:intentions] ||= {}
        layer[:choices].each do |key, value|
          @structure[:choices][key] = value
          @structure[:intentions][key] = value[:default]
        end
      end

      def overlay_intentions(layer)
        layer[:intentions].each do |key, value|
          @structure[:intentions][key] = value
        end
      end

      def sanitize(options)
        options ||= {}
        options.transform_keys!(&:to_sym)
        options.each do |key, value|
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

      def get_layer(filedir)
        filepath = "#{filedir}.yml"
        # key = filed.split('/').last
        # error_msg = "Cannot find that story #{key} at #{filepath}. Has it been written?"
        raise Roro::Error, "Can't find story" unless File.exist?(filepath)

        json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
        json || raise(Roro::Story::StoryMissing, "Is #{filepath} empty?")
      end

      def story_map(story = 'stories')
        array ||= []
        loc = Roro::CLI.story_root + "/#{story}"
        validate_story(loc)
        stories = Dir.glob("#{loc}/*.yml")
        stories.each do |ss|
          name = ss.split('/').last.split('.yml').first
          array << { name.to_sym => story_map([story, name].join('/'))}
        end
        array
      end

      def default_story(story = 'rollon', loc = nil)
        hash = {}
        loc = [(loc ||= Roro::CLI.story_root), story].join('/')
        substory = get_layer(loc)[:stories]
        if substory.is_a?(Array)
          array = []
          substory.each do |s|
            ss = get_layer([loc, s].join('/'))[:stories]
            array << (ss.is_a?(String) ? { s.to_sym => ss.to_sym } : default_story( s, loc ) )
          end
          hash[story.to_sym] = array
        else
          hash[story.to_sym] = default_story(substory, loc)
        end
        hash
      end

      def validate_story(story)
        scenes = get_layer(story)[:stories]
        case scenes
        when String
          File.exist?("#{story}#{scenes}.yml")
        when Array
          scenes.each { |scene| validate_story("#{story}/#{scene}") }
        end
      end
    end
  end
end