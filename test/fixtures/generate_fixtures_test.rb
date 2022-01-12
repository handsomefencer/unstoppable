# frozen_string_literal: true

require 'test_helper'

describe 'generate fixtures' do
  Given(:file)    { "test/fixtures/matrixes/itineraries.yml" }
  Given(:cases)   { read_yaml("#{Dir.pwd}/test/fixtures/matrixes/cases.yml") }
  Given(:content) { read_yaml("#{Dir.pwd}/#{file}") }
  Given(:generate_file) do
    File.open("#{Dir.pwd}/#{file}", "w+") do |f|
      itineraries = []
      cases.each do |c|
        kases = c.unshift('1')
        Roro::Configurators::AdventurePicker
          .any_instance
          .stubs(:ask)
          .returns(*c)
        chooser = AdventureChooser.new
        chooser.build_itinerary
        itineraries << chooser.itinerary
      end
      f.write(itineraries.to_yaml)
    end
  end


  Given { generate_file unless File.exist?(file) }

  Then { assert_file file }
  # And {   assert_equal 33, content }

end
