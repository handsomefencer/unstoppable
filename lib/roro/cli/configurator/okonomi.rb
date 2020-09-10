require 'yaml'
require 'json'
require 'pathname'

module Roro
  class Configurator < Thor::Shell::Basic
  
    def configurator_root 
      File.dirname(__FILE__)
    end
  
    def story_map(map='stories')
      array ||= []
      story_root = configurator_root + "/#{map}"
      validate_substories(story_root)
      stories = Dir.glob(story_root + "/*.yml") 
      stories.each do |story| 
        name = story.split('/').last.split('.yml').first
        array << { name.to_sym => story_map([map, name].join('/'))}
      end   
      array
    end
    
    def default_story(story='stories', location=nil)
      hash ||= {}
      location ||= configurator_root + '/' + story
      stories = get_layer(location + ".yml")[:stories]
      case stories
      when String 
        hash[story.to_sym] = default_story(stories, "#{location}/#{stories}")
      when Array
        array = []
        stories.each do |substory| 
          if get_layer(location + '/' + substory + '.yml')[:stories].is_a? String
            array << { substory.to_sym => get_layer(location + '/' + substory + '.yml')[:stories].to_sym }  
          else   
            array << default_story(substory, "#{location}/#{substory}" )  
          end 
        end
        hash[story.to_sym] = array
      end
      hash
    end
    
    def validate_substories(story)
      substories = get_layer("#{story}.yml")[:stories]
      if substories.is_a? String
        File.exist?(story + substories + '.yml')
      elsif substories.is_a? Array 
        substories.each { |substory| validate_substories(story + '/' + substory) }
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