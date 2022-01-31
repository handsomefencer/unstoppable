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
        gsub_file file, /\ndescribe (.*)[\s\S]*\n\s\sdescribe/ do |match|
          # describe_dummy_file(dummy_file_name)
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
        getsome.map! { |i| i[1].eql?('versions') ? "#{i[0]}-#{i[-1]}" : i.last }
        "adventure::#{getsome.shift}::#{index} #{getsome.join(' & ')}"
      end

      def description_helper(adventure_test)

      end


      def describe_outmost(description)
        [
          "\ndescribe '#{description}' do",
          "\s\sGiven(:workbench)  { }",
          "\s\sGiven { @rollon_loud    = false }",
          "\s\sGiven { @rollon_dummies = false }",
          "\s\sGiven { rollon(__dir__) }",
          "\s\sGiven(:assert_content) { -> (c) { assert_file file, c }",
          "\n\s\sdescribe"
        ].join("\n")
      end

      def describe_dummy_file_with(dummy_file)
        [
          "\ndescribe '#{dummy_file}' do",
          "\s\sGiven(:workbench)  { }",
          "\s\sGiven { @rollon_loud    = false }",
          "\s\sGiven { @rollon_dummies = false }",
          "\s\sGiven { rollon(__dir__) }",
          "\s\sGiven(:assert_content) { -> (c) { assert_file file, c }",
          "\n\s\sdescribe"
        ].join("\n")

      end

      def describe_actions(test_file)

      end

      def describe_after_actions(test_file)
        [
          "\n\s\sdescribe 'must have generated' do",

        ].join("\n")
      end

      def describe_before_actions(test_file)
        story = "#{stack_name(File.expand_path('../../..', test_file))}.yml"
        [
          "\n\s\sdescribe ':actions in #{story}' do",
          "\n\s\s\s\sdescribe 'before' do",
          "\n\s\s\s\send",
          "\s\sGiven(:workbench)  { }",
          "\s\sGiven { @rollon_loud    = false }",
          "\s\sGiven { @rollon_dummies = false }",
          "\s\sGiven { rollon(__dir__) }",
          "\s\sGiven(:assert_content) { -> (c) { assert_file file, c }",
          "\n\s\sdescribe"
        ].join("\n")
      end

      # def describe_block_for(dummy)
      #   dummy_path = dummy.split('/dummy/').last
      #   [
      #     "\n\s\sdescribe '#{dummy_path}' do",
      #     "\s\s\s\sGiven { rollon }",
      #     "\s\s\s\sGiven(:file) { '#{dummy_path}' }",
      #     "\s\sGiven { rollon(__dir__) }",
      #     "\n\s\send"
      #   ].join("\n")
      # end


      def dummies_path_for(test_file)
        path = test_file.split('/_test.rb').first
        test_file
        Dir.glob("#{path}/dummy/**/*")
      end


      def dummies_path_for(test_file)
        path = test_file.split('/_test.rb').first
        test_file
        Dir.glob("#{path}/dummy/**/*")
      end

      def dummy_assertions(dummy_file_name)
        [
          "Given(:file) { '#{dummy_file_name} ' } ",
          "Then { assert_file '#{dummy_file_name}" ,
          "And  { assert_file '#{dummy_file_name}, 'some string",
          "And  { assert_content 'some string' }",
        ]
      end

      def indent(array)
        array.map { |s| "\s\s#{s}"}
      end

      def describe_dummy_file(dummy_file_name)
        <<-HEREDOC

  describe 'must generate' do
    describe '#{dummy_file_name}' do
      Given(:file) { '#{dummy_file_name}' }
      Then { assert_file file }
      And  { assert_file file, 'foo' }
  
      describe 'must have contents like' do 
        Given(:assert_content) { -> (c) { assert_file file, c } }
        
        Then { assert_content['foo'] }
      end
    end 
  end
        HEREDOC
      end
      # def describe_dummy_file(dummy_file_name)
      #   array = [
      #     "describe 'must generate' do"
      #   ]
      #   array += indent( dummy_assertions( dummy_file_name ) )
      #   indent(array).join("\n")
      # end


      def dummy_assertions(dummy_file_name)
        array = [
          "describe '#{dummy_file_name}' do",
          "  Given(:file) { '#{dummy_file_name}' } ",
          ''
        ]
        array += indent(dummy_assert_file(dummy_file_name))
        array + indent(dummy_assert_content(dummy_file_name))
      end

      def dummy_assert_content(dummy_file_name)
        array = [
          "describe 'content must equal' do ",
          "  Then { assert_file file }",
          'end'
        ]
        array
      end

      def dummy_assert_file(dummy_file_name)
        array = [
          "describe 'must exist' do ",
          "  Then { assert_file file }",
          'end'
        ]
        array
      end

      def dummy_assert_contents(dummy_file_name)
        [
          "Then { assert_file '#{dummy_file_name}' }",
        ].map {|s| "\n#{s}"}
      end

      def dummy_assert_file_contents(dummy_file_name)
        [
          "describe 'file' do",
          "  Then { assert_file '#{dummy_file_name}' }",
        ]
      end

      def dummies_for(adventure_test)
        Dir.glob("#{dummy_path_for(adventure_test)}/**/*")
           .map {|f| f.split("#{Dir.pwd}/").last }
      end

      def dummy_path_for(adventure_test)
        File.expand_path('../dummy', adventure_test)
      end

      def story_path_for(adventure_test)
        File.expand_path('../../..', adventure_test)
      end

      def adventure_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
           .map {|f| f.split("#{Dir.pwd}/").last }
      end
    end
  end
end
