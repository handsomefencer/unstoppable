require 'yaml'
require 'json'
module Roro
  class Configurator < Thor::Shell::Basic
    
    def default_story(story, location=nil)
      default_story = {}
      story.each do |key, value| 
        location = location ? (location + '/' + key.to_s ) : key.to_s
        filedir = File.dirname(__FILE__) + "/#{location}"
        filepath = "#{filedir}.yml"
        layer = get_layer(filepath) 
        case 
        when value.is_a?(Array)
          value.each {|v| build_layers(v, location) }
        when value.empty?
          if layer[:story]
            byebug
            default_story[:key] = layer[:story]
            # byebug
          else  
          end 
        # when value.is_a?(Hash) 
        #   default_story = 
          
          # build_default_story(value, location) 
        end
      end
      default_story 
    end 
    
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