# frozen_string_literal: true

require 'test_helper'

describe 'fixtures' do
  Given(:matrixes_path)   { 'test/fixtures/matrixes' }
  Given(:cases_loc)       { "#{matrixes_path}/cases.yml" }
  Given(:itineraries_loc) { "#{matrixes_path}/itineraries.yml" }
  Given(:cases)           { read_yaml(cases_loc) }
  Given(:itineraries)     { read_yaml(itineraries_loc) }
  Given(:itinerary)       { itineraries[cases.index(adventure)][0] }

  Given { generate_fixtures }

  describe 'must exist in' do
    describe 'itineraries.yml' do
      Then { assert_file itineraries_loc }
    end

    describe 'cases.yml' do
      Then { assert_file cases_loc }
    end
  end

  describe 'must contain correct number of' do
    describe 'cases' do
      Then { assert_equal 27, cases.size }
    end

    describe 'itineraries' do
      Then { assert_equal itineraries.size, cases.size }
    end
  end

  describe 'must be correct when' do
    describe 'simple' do
      Given(:adventure) { [1,1] }

      Then { assert_equal cases[0], adventure }
      And  { assert_match(/ci_styles\/circleci/, itinerary) }
    end

    describe 'intermediate' do
      Given(:adventure) { [3,1,2,1] }
      Then { assert_includes cases, adventure }
      And  { assert_match(/flask/, itinerary) }
    end

    describe 'advanced' do
      Given(:adventure) { [3,2,1,1,2,2,1] }
      Then { assert_includes cases, adventure }
      And  { assert_match(/rails/, itinerary) }
    end
  end
end
