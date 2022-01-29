# frozen_string_literal: true

module Roro

  class CLI < Thor

    desc 'generate:annotations', 'Generate annotations for adventure tests.'
    map 'generate:annotations' => 'generate_annotations'

    method_options :annotations => :array

    def generate_annotations
      files = adventure_test_files
      files.each do |file|
        gsub_file file, /^describe ["](.*?)["]/ do |match|
          adventure_description(file.split('lib/roro/stacks').last)
        end
      end
    end

    no_commands do

      def adventure_description(stack)
        index = stack.split('/')[-2]
        story = stack.split('lib/roro/stacks').last.split("/test/#{index}/_test.rb").first
        itineraries = read_yaml("#{Roro::CLI.test_root}/fixtures/matrixes/itineraries.yml")
        adventures = itineraries
          .select { |i| i.include?(story) }[index.to_i].unshift(story).uniq!
          .map { |i| i.split('/')[-3..-1] }
          .each { |i| i.delete('versions') }
          .map { |i| i.size.eql?(3) ? i.last : i.join('_') }
        "describe 'adventure::#{adventures.shift}::#{index}::#{adventures.join(' & ')}'"
      end

      def adventure_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
           .map {|f| f.split("#{Dir.pwd}/").last }
      end
    end
  end
end
