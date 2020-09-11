require 'yaml'
require 'json'

module Roro
  module Configurator
    module Okonomi  
  
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
      
      def get_story(location)
        get_layer(location + ".yml")[:stories]
      end 
      
      def golden(story='rollon', loc=nil)
        hash = {}
        loc = [(loc ||= Roro::CLI.story_root), story].join('/') 
        substory = get_story(loc)
        if substory.is_a?(Array)
          array = []
          substory.each do |s| 
            ss = get_story([loc, s].join('/'))
            array << (ss.is_a?(String) ? { s.to_sym => ss } : golden( s, loc ) ) 
          end
          hash[story.to_sym] = array
        else 
          hash[story.to_sym] = golden(substory, loc)
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
      
      # def default_story(map='stories')
      #   hash = { }
      #   location = location.nil? ? map : location + map 
      #   story_dir = File.dirname(__FILE__) + "/#{location}"
      #   story_path = story_dir + '.yml'
      #   stories = Dir.glob(story_path)
        
      #   substories = get_layer(story_path)[:stories]
      #   hash[map] = substories
      #   if substories.is_a?(String) 
      #     hash[substories] = default_story(map)
      #   elsif substories.is_a?(Array)
      #     # byebug
      #   end
      #   hash
      #   # array ||= []
      #   # stories.each do |story| 
      #   #   layer = get_layer(story)
      #   #   next if layer[:stories].nil?
      #   #   name = story.split('/').last.split('.yml').first
      #   #   array << { name.to_sym => layer[:stories]}
      #   #   # byebug
      #   # end   
      #   # array
      # end

      # def default_story(story= { stories: {} }, location=nil )
      #   story.each do |key, value| 
      #     story_name = key.to_s
      #     location = location.nil? ? story_name : [location, story_name].join('/')
      #     filedir = File.dirname(__FILE__) + "/" + location
      #     filepath = "#{filedir}.yml"
      #     layer = get_layer(filepath)
      #     stories = layer[:stories]
      #     story[key] = stories
      #     # byebug if value.nil?
      #     if stories.is_a? Hash 
      #       default_story(stories, location)
      #     elsif stories.is_a? Array 
      #       stories.each { |s| default_story(s, location) }
      #     end
      #   end
      #   story 
      # end
      
        # story ||= { stories: {}}
        # layer = get_layer(filepath)
        # story[story_name] = stories 
        # case 
        # when stories.is_a?(Hash) 
        #   default_story()
        # when stories.is_a?(Array) 
        # end
        # # story.each do |key, value| 
        # #   location ||= key.to_s
        # #   interest = layer[:stories] 
            
        # #   # story[key] = 
        # # end
        
        # # # @options[:story]
        # location
        # story
        # # interest
      # end
      # def default_story(story, location=nil)
      #   story ||= {}
      #   story.each do |key, value|
      #     location ||= key.to_s
      #     filedir = File.dirname(__FILE__) + "/#{location}"
      #     filepath = "#{filedir}.yml"
      #     byebug if !File.exist? filepath# byebug
      #     layer = get_layer(filepath)
      #     # case
      #     # if value.is_a?(Array)
      #     # value.each {|v| build_layers(v, location) }
      #     # when value.empty?
      #     if layer[:story]
      #       story[key] = layer[:story]
      #       filename = story[key].keys.first.to_s# byebug
      #       location = location ? (location + '/' + filename) : filename
      #       default_story(story, location)
      #     elsif layer[:stories]
      #       byebug
      #       # else
      #       # end
      #     # when value.is_a?(Hash)
      #     #   default_story =

      #       # build_default_story(value, location)
      #     end
      #   end
      #   story
      # end

      def take_order

        ask_questions
      end

      def ask_questions
        @structure[:choices].each do |key, value|
          @structure[:intentions][key] = ask_question(value)
        end
      end

      def ask_question(question)
        prompt = question[:question]
        default = question[:default]
        choices = question[:choices].keys
        answer = ask(prompt, default: default, limited_to: choices)
        answer
      end
    end
  end
end