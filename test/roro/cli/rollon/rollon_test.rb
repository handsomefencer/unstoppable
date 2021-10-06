require "test_helper"

describe 'Roro::CLI#rollon' do
  Given(:cli)    { Roro::CLI.new }
  Given(:rollon) { cli.rollon }

  context 'when fatsufodo django' do
    let(:stub_journey) { Thor::Shell::Basic
                           .any_instance
                           .stubs(:ask)
                           .returns(*answers)}
    Given { Roro::Configurators::QuestionAsker
              .any_instance
              .stubs(:confirm_default)
              .returns('y') }

    context 'when fatsufodo django' do
      let(:workbench)    { nil }

      let(:options) { {} }
      let(:answers) { %w[fatsufodo django] }
      # Given { stub_journey }
      Given { rollon }
      # Given { config.validate_stack }
      # Given { config.choose_adventure }
      # Given { config.build_manifest }
      focus
      Then  do
        assert_file 'unstoppable_django/Dockerfile', /FROM/

        # assert_file_match_in 'stories/django', config.itinerary
        # assert_equal 1, config.itinerary.size
        # assert_equal 2, config.manifest.size
        # assert_file_match_in('fatsufodo.yml', config.manifest)
        # assert_file_match_in('django/django.yml', config.manifest)
      end
    end
  end
end