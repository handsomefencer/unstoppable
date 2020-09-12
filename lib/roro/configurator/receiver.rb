module Roro
  module Configurator
    module Receiver 
      
      attr_reader :structure, :intentions, :env, :options, :story

      def initialize(options=nil)
        @options = sanitize(options)
        @structure = { 
                       choices:    {},
                       env_vars:   {},
                       intentions: {}, 
                       story:      {} 
        }
        @story = @options[:story].nil? ? default_story : { rollon: @options[:story] }
        if @options.keys.include?(:greenfield)
          @structure[:greenfield] = true
          build_layers({ greenfield: :rails }) 
        end
        build_layers(@story)
        @intentions = @structure[:intentions]
        @env = @structure[:env_vars]
        @env[:main_app_name] = Dir.pwd.split('/').last 
        @env[:ruby_version] = RUBY_VERSION
        @env[:force] = true
        @env[:verbose] = false
        screen_target_directory 
      end
  
      def sanitize(options)
        options ||= {}
        options.transform_keys!{|k| k.to_sym}
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
      
      def get_story(location)
        get_layer(location + ".yml")[:stories]
      end 
   
      def get_layer(filepath) 
        if !File.exist?(filepath)
          key = filepath.split('/').last.split('.yml')
          error_msg = "Cannot find that story #{key} at #{filepath}. Has it been written?" 
          raise (Roro::Error.new(error_msg)) 
        end   
        json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
        json ? json : ( raise (Roro::Error.new(error_msg))) 
      end
    end 
  end 
end