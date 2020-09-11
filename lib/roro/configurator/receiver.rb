module Roro
  module Configurator
    module Receiver 
      
      attr_reader :structure, :intentions, :env, :options, :actions

      def initialize(options=nil)
        options ||= {}
        options[:story] ||=  { rails: {} } 
        sanitize(options)
        @structure = {
          choices:    {},
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
        @options = options
      end
      
    end 
  end 
end