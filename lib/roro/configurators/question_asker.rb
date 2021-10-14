# frozen_string_literal: true

module Roro
  module Configurators
    class QuestionAsker < Thor

      include Thor::Actions

      no_commands do
        def override_default(question)
          prompt = "Please supply a value:"
          answer = ask([question, prompt].join("\n"))
          answer.size > 1 ? answer : override_default(question)
        end

        def confirm_default(question)
          options = { "y": "yes", "n": "no"}
          humanized_options = options.map {|key, value|
            "(#{key}) #{value}"
          }
          getsome = "Would you like to accept the default value?\n"
          prompt = [question, getsome, humanized_options, "\n"].join("\n")
          answer = ask(prompt, limited_to: options.keys.map(&:to_s))
          answer.eql?('n') ? override_default(question) : 'y'
        end
      end
    end
  end
end
