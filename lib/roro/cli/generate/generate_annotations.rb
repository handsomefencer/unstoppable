# frozen_string_literal: true

module Roro

  class CLI < Thor

    desc 'generate:annotations', 'Generate annotations for adventure tests.'
    map 'generate:annotations' => 'generate_annotations'

    def generate_annotations(*files)
      files ||= adventure_test_files
      files.each do |adventure_test|
        gsub_file adventure_test, /\nrequire (.*)[\s\S]*\n\s\sdescribe/ do |match|
          adventure_boilerplate(adventure_test) + "\s\sdescribe"
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

      def adventure_boilerplate(adventure_test)
<<-HEREDOC

require 'test_helper'

describe '#{adventure_description(adventure_test)}' do
  Given(:workbench) { }

  Given { @rollon_loud    = false }
  Given { @rollon_dummies = false }
  Given { rollon(__dir__) }
  
  describe 'directory must contain' do
#{description_helper(adventure_test)}  end


HEREDOC
      end

      def description_helper(adventure_test)
        dummies_for(adventure_test)
          .map! { |d| describe_dummy_file(d) }
          .join("\n")
      end

      def describe_dummy_file(dummy_file_name)
        <<-HEREDOC
    describe '#{dummy_file_name}' do
      Given(:file) { '#{dummy_file_name}' }
      Then { assert_file file }
  
      describe 'must have content' do 
        describe 'equal to' do 
          Then { assert_file file, 'foo' }
        end

        describe 'matching' do 
          Then { assert_file file, /foo/ }
          Then { assert_content file, /foo/ }
        end
      end
    end
        HEREDOC
      end

      def dummies_for(adventure_test)
        dummies = Dir.glob("#{dummy_path_for(adventure_test)}/**/*")
        if dummies.empty?
          ['README.md']
        else
          dummies
            .select { |d| File.file?(d) }
            .map { |f| f.split("/dummy/").last }
        end
      end

      def dummy_path_for(adventure_test)
        File.expand_path('../dummy', adventure_test)
      end

      def story_path_for(adventure_test)
        File.expand_path('../../..', adventure_test)
      end

      def adventure_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
           .map { |atf| atf.split("#{Dir.pwd}/").last }
      end
    end
  end
end
