module Roro
  module Configurator
    module Receiver 
      
      attr_reader :structure, :intentions, :env, :options

      def initialize(options=nil)
        @options = sanitize(options)
        @options[:story] ||=  { rails: {} } 
        @structure = { choices:    {},
                       env_vars:   {},
                       intentions: {}, 
                       story:      {} 
        }
        build_layers(rollon: @options[:story])
        @intentions = @structure[:intentions]
        @env = @structure[:env_vars]
        @env[:main_app_name] = Dir.pwd.split('/').last 
        @env[:ruby_version] = `ruby -v`.scan(/\d.\d/).first
        screen_target_directory 
      end
  
      def sanitize(options)
        options ||= {}
        options.transform_keys!{|k| k.to_sym}
        options.each do |k, v| 
          case v
          when Array
            v.each { |vs| sanitize(vs) }
          when Hash 
            sanitize(v)
          when true 
            options[k] = {}
          when
            options[k] = { v.to_sym => {}} 
          end
        end
      end
      
      def get_story(location)
        get_layer(location + ".yml")[:stories]
      end 
      
      def get_layer(filepath) 
        json = JSON.parse(YAML.load_file(filepath).to_json, symbolize_names: true)
        json ? json : ( raise (Roro::Error.new(error_msg))) 
      end
    end 
  end 
end