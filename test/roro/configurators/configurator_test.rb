# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  Given(:options)    { {} }
  Given(:config)     { Configurator.new(options) }
  Given(:adventures) { %w[ fatsufodo django ] }

  Given { Roro::Configurators::AdventurePicker
            .any_instance
            .stubs(:ask)
            .returns *journey_choices(*adventures.map(&:to_sym)) }

  context 'without options' do
    describe '#initialize' do
      Then { assert_match 'developer_styles', config.stack }
      And  { assert_equal Hash, config.structure.class }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end

    describe '#choose_adventure' do
      Given { quiet { config.choose_adventure } }

      context 'when fatsufodo' do
        context 'when django' do
          When(:adventures) { %w[ fatsufodo django ] }
          Then {
            assert_file_match_in 'stories/django', config.itinerary }
        end

        context 'when wordpress' do
          When(:adventures) { %w[ fatsufodo wordpress ] }
          Then { assert_file_match_in 'stories/wordpress', config.itinerary }
        end

        context 'when rails' do
          When(:adventures) { %w[ fatsufodo rails ] }
          Then { assert_file_match_in 'stories/rails', config.itinerary }
        end
      end
    end
  end

  context 'when stack path' do
    Given(:options) { { stack: stack_path } }

    describe '#initialize' do
      Then { assert_match 'stack/valid', config.stack }
    end

    describe '#validate_stack' do
      Then { assert_nil config.validate_stack }
    end
  end
end
