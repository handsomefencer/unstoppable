# frozen_string_literal: true

require 'test_helper'

describe 'Stories: Roro' do
  let(:workbench) { nil }
  let(:options)   { nil }
  let(:subject)   { Configurator }
  let(:config)    { subject.new(options) }
  let(:plot_root) { "#{Roro::CLI.catalog_root}" }

  let(:scene) { plot_root }
  let(:story) { { roro: {} } }

  Given do
    Roro::Configurators::Configurator
      .any_instance
      .stubs(:story)
      .returns(story)
  end
  Given { config.write_story }
  Then  { assert_file 'roro/env/.keep' }
  And   { assert_file 'roro/containers/.keep' }
  And   { assert_file 'roro/keys/.keep' }
  And   { assert_file 'roro/scripts/.keep' }
end
