module Roro
  class CLI < Thor
        
    no_commands do
     
      def configure_for_rollon
        confirm_dependencies
        @config ||= Roro::Configuration.new(options) 
      end

      def configurator_for_rollon
        confirm_dependencies
        @config ||= Roro::Configurator.new(options) 
      end

      def yaml_from_template(file)
        File.read(File.dirname(__FILE__) + "/templates/#{file}")
      end
      
      def take_thor_actions 
        @config.thor_actions.each {|k, v| eval(k) if v.eql?('y') }  
      end
    end
  end
end