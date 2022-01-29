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
          string = adventure_description(file.split('lib/roro/stacks').last)
          "describe \"#{string}\""
        end
      end
    end

    no_commands do

      def adventure_description(stack)
        index = stack.split('/')[-2]
        story = stack.split("/test/#{index}/_test.rb").first
        itineraries = read_yaml("#{Roro::CLI.test_root}/fixtures/matrixes/itineraries.yml")
        itineraries.select! { |i| i.include?(story) }[index.to_i]
        adventures = itineraries[index.to_i]
        adventures.map! do |i|
          i.split('/')[-3..-1]
        end
        adventures.map! do |i|
          i.delete('versions')
          i.size.eql?(3) ? i.last
            : i.join('_')
        end
        adventures.join('-')
      end

      # def itineraries
      #   read_yaml("#{Roro::CLI.test_root}/fixtures/matrixes/itineraries.yml")
      # end

      def adventure_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
           .map {|f| f.split("#{Dir.pwd}/").last }
      end
    end
  end
end
