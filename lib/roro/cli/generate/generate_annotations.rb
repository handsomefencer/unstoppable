# frozen_string_literal: true

module Roro

  class CLI < Thor

    desc 'generate:annotations', 'Generate annotations for adventure tests.'
    map 'generate:annotations' => 'generate_annotations'

    method_options :annotations => :array

    def generate_annotations
      files = adventure_test_files
      files.each do |file|
        stack_location = file.split('lib/roro/stacks').last
        description = adventure_description(stack_location)
        # describe (.*)[\s\S]*\n\s\sdescribe
        gsub_file file, /\ndescribe (.*)[\s\S]*\n\s\sdescribe/ do |match|
          [
            "describe '#{description}' do",
            "\s\sGiven(:workbench)  { }",
            "\s\sGiven { @rollon_loud    = true }",
            "\s\sGiven { @rollon_dummies = false }",
            "\s\sGiven { rollon(__dir__) }",
            "\s\sdescribe"
          ].join("\n")
        end
      end
    end

    no_commands do

      def adventure_description(stack)
        index = stack.split('/')[-2]
        story = stack.split('lib/roro/stacks').last.split("/test/#{index}/_test.rb").first
        adventures = read_yaml("#{Roro::CLI
                                 .test_root}/fixtures/matrixes/itineraries.yml")
        adventures.select! { |i| i.include?(story) }
        getsome = adventures[index.to_i]
        return unless getsome&.include?(story)
        getsome.delete(story)
        getsome.unshift(story)
        getsome.map! { |i| i.split('/')[-3..-1] }
        getsome.delete(story)
        getsome.map! { |i| i[1].eql?('versions') ? "#{i[0]}_#{i[-1]}" : i.last }
        "adventure::#{getsome.shift}::#{index}::#{getsome.join(' & ')}"
      end

      def adventure_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
           .map {|f| f.split("#{Dir.pwd}/").last }
      end
    end
  end
end
