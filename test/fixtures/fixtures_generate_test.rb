# frozen_string_literal: true

require 'test_helper'

describe '(helper) generate_fixtures' do
  Given(:workbench)       { 'test' }
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:case_builder)    { AdventureCaseBuildr.new(stack_loc) }
  Given(:matrixes_path)   { 'test/fixtures/matrixes' }
  Given(:cases_loc)       { "#{matrixes_path}/cases.yml" }
  Given(:itineraries_loc) { "#{matrixes_path}/itineraries.yml" }
  Given(:cases)           { read_yaml(cases_loc) }
  Given(:itineraries)     { read_yaml(itineraries_loc) }
  Given(:itinerary)       { itineraries[cases.index(adventure)][0] }

  Given { generate_fixtures }

  describe 'must generate fixture file in' do
    describe 'itineraries.yml' do
      Then { assert_file itineraries_loc }
    end

    describe 'cases.yml' do
      Then { assert_file cases_loc }
    end
  end
end