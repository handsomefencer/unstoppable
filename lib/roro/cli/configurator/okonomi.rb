require 'yaml'
require 'json'
module Roro
  class Configurator < Thor::Shell::Basic

    def default_story(story, location=nil)
      story ||= {}
      story.each do |key, value|
        location ||= key.to_s
        filedir = File.dirname(__FILE__) + "/#{location}"
        filepath = "#{filedir}.yml"
        byebug if !File.exist? filepath# byebug
        layer = get_layer(filepath)
        # case
        # if value.is_a?(Array)
        # value.each {|v| build_layers(v, location) }
        # when value.empty?
        if layer[:story]
          story[key] = layer[:story]
          filename = story[key].keys.first.to_s# byebug
          location = location ? (location + '/' + filename) : filename
          default_story(story, location)
        elsif layer[:stories]
          byebug
          # else
          # end
        # when value.is_a?(Hash)
        #   default_story =

          # build_default_story(value, location)
        end
      end
      story
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