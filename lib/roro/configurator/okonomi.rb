require 'yaml'
require 'json'

module Roro
  module Configurator
    module Okonomi  
  
      def take_order
        ask_questions
      end

      def ask_questions
        choices = @structure[:choices] 
        choices.each do |key, value|
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