# frozen_string_literal: true

require 'test_helper'

describe 'generate fixtures' do
  Given(:cases) { read_yaml("#{Dir.pwd}/test/fixtures/matrixes/cases.yml") }
  Given(:file) { "test/fixtures/matrixes/itineraries.yml" }
  Given(:content)         { read_yaml("#{Dir.pwd}/#{file}") }

  Given do

    File.open("#{Dir.pwd}/test/fixtures/matrixes/itineraries.yml", "w+") do |f|
      itineraries = []
      cases.each do |c|
        kases = c.unshift('1')
        Roro::Configurators::AdventurePicker
          .any_instance
          .stubs(:ask)
          .returns(*kases)
        chooser = AdventureChooser.new
        itineraries << chooser.build_itinerary
      end
      f.write(itineraries.to_yaml)

    end
  end

  Then { assert_file file }
  And {   assert_equal 33, content }

end
