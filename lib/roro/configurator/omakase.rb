module Roro
  module Configurator
    module Omakase 
      
      def build_layers(story, location=nil)
        story = !story.is_a?(Hash) ? { story.to_sym => {}} : story
        story.each do |key, value| 
          story = key
          location = location ? "#{location}/#{key.to_s}" : key.to_s
          case value 
          when Array
            value.each {|value| build_layers(value, location) }
          when  
            build_layers(value, location)
          end
          
          filedir = "#{Roro::CLI.story_root}/#{location}"
          filepath = "#{filedir}.yml"
          layer = get_layer(filepath) 
          overlay(layer)
        end
      end 
      
      def overlay(layer)
        layer.each { |key, value| @structure[key] ||= value }
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
        layer[:choices].each do |key, value|
          @structure[:choices][key] = value
          @structure[:intentions][key] = value[:default]  
        end
      end
      
      def story_map(story='stories')
        array ||= []
        loc = Roro::CLI.story_root + "/#{story}"
        validate_story(loc)
        stories = Dir.glob(loc + "/*.yml") 
        stories.each do |ss| 
          name = ss.split('/').last.split('.yml').first
          array << { name.to_sym => story_map([story, name].join('/'))}
        end   
        array
      end
            
      def default_story(story='rollon', loc=nil)
        hash = {}
        loc = [(loc ||= Roro::CLI.story_root), story].join('/') 
        substory = get_story(loc)
        if substory.is_a?(Array)
          array = []
          substory.each do |s| 
            ss = get_story([loc, s].join('/'))
            array << (ss.is_a?(String) ? { s.to_sym => ss.to_sym } : default_story( s, loc ) ) 
          end
          hash[story.to_sym] = array
        else 
          hash[story.to_sym] = default_story(substory, loc)
        end
        hash
      end
      
      def validate_story(story)
        substories = get_layer("#{story}.yml")[:stories]
        if substories.is_a? String
          File.exist?(story + substories + '.yml')
        elsif substories.is_a? Array 
          substories.each { |substory| validate_story(story + '/' + substory) }
        end 
      end 
    end 
  end 
end