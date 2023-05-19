# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:harvest', 'Generate harvest.'
    map 'generate:harvest' => 'generate_harvest'

    def generate_harvest
      reflector = Roro::Reflector.new
      content = {
        cases: reflector.cases.map { |c| c.join(' ') },
        structure_human: reflector.adventure_structure_human,
        structure_choices: reflector.adventure_structure_choices
        # itineraries: harvest_itineraries,
        # metadata: @reflector.metadata
      }
      content.each do |key, value|
        create_file ".harvest/#{key}.yml", value.to_yaml
      end
    end

    no_commands do
      def harvest_itineraries
        itineraries = {}
        @reflector.itineraries.each do |i|
          itineraries[harvest_adventure_title(i)] = 'blah'
        end
        itineraries
      end

      def harvest_adventure_title(itinerary)
        array = []
        itinerary.each do |i|
          parent_path = stack_parent_path(i)
          # if stack_parent(i).eql?('versions')
          #   keyword = stack_parent(parent_path)
          # else
          # end
          keyword = i.split('/').last(3) - %w[adventures databases versions frameworks]
          array << keyword.join('_')
        end
        array.join('-')
      end

      def harvest_test_files
        harvest = {}
        harvest[:test_files] = gather_test_files
        create_file '.harvest.yml', harvest.to_yaml
      end

      def gather_test_files
        Dir.glob("#{Dir.pwd}/lib/roro/stacks/**/*_test.rb")
      end
    end
  end
end
