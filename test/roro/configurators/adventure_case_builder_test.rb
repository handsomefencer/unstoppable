# frozen_string_literal: true

require 'test_helper'

describe AdventureCaseBuilder do
  Given(:stack_loc)       { Roro::CLI.stacks }
  Given(:case_builder)    { AdventureCaseBuilder.new(stack_loc) }
  Given(:matrixes_path)   { 'test/fixtures/matrixes' }
  Given(:cases_loc)       { "#{matrixes_path}/cases.yml" }
  Given(:itineraries_loc) { "#{matrixes_path}/itineraries.yml" }
  Given(:cases)           { read_yaml(cases_loc) }
  Given(:itineraries)     { read_yaml(itineraries_loc) }

  let(:generate_fixtures) {
    generate_fixture_cases unless File.exist?(cases_loc)
    generate_fixture_itineraries #unless File.exist?(itineraries_loc)
  }

  let(:generate_fixture_cases) {
    File.open(cases_loc, "w+") { |f|
      builder = Roro::Configurators::AdventureCaseBuilder.new
      f.write(builder.build_cases_matrix.to_yaml)
    }
  }

  let(:generate_fixture_itineraries) {
    File.open(itineraries_loc, "w+") { |f|
      itineraries = []
      cases.each { |c|
        Roro::Configurators::AdventurePicker
          .any_instance
          .stubs(:ask)
          .returns(*c)
        chooser = AdventureChooser.new
        chooser.build_itinerary
        itineraries << chooser.itinerary
      }
      f.write(itineraries.to_yaml)
    }
  }

  describe '#build_cases' do
    When(:expected) { [:inflections, :stacks, :stories] }
    Then { assert_equal expected, case_builder.build_cases.keys }
  end

  describe '#generate_fixtures' do
    Given { generate_fixtures }

    describe 'must generate' do
      describe 'fixture file in' do
        describe 'itineraries.yml' do
          Then { assert_file itineraries_loc }
        end

        describe 'cases.yml' do
          Then { assert_file cases_loc }
        end
      end

      describe 'correct number of' do
        describe 'cases' do
          Then { assert_equal 33, cases.size }
        end

        describe 'itineraries' do
          Then { assert_equal 33, itineraries.size }
        end
      end

      describe 'simple' do
        Given { skip }
        Then { assert_includes cases, [1,1] }
        And  { assert_includes itineraries, [1,1] }
      end
    end


    describe 'intermediate case' do
      Then { assert_includes cases, [3,1,2,1] }
    end

    describe 'advanced case' do
      Then { assert_includes cases, [3,2,1,1,2,2,1] }
    end
  end

  describe '#case_from_path' do
    Given(:stack) { %W[#{Roro::CLI.stacks}/sashimi
      stories/kubernetes
      stories/ingress
      stories/nginx
      stories/cert_manager].join('/')}
    Given(:expected) { %w[sashimi kubernetes ingress nginx cert_manager] }
    # Then { assert_equal expected, case_builder.case_from_path(stack) }
  end

  describe '#case_from_stack' do
    Given(:stack) { %W[#{Roro::CLI.stacks}/sashimi
      stories/kubernetes
      stories/ingress
      stories/nginx
      stories/cert_manager].join('/')}
    Given(:expected) { [5, 1, 1, 1, 1] }
    # Then { assert_equal expected, case_builder.case_from_stack(stack) }
  end

  ## helpers

end
