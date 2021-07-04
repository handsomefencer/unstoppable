# frozen_string_literal: true

require 'test_helper'

describe 'Stories: Roro' do
  let(:workbench) { nil }
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/catalog/roro" }
  let(:scene) { plot_root }
  let(:story) { { roro: {} } }
  let(:command) { omakase.write_story }

  Given do
    Roro::Configurators::Omakase
      .any_instance
      .stubs(:story)
      .returns(story)
  end
  Given { omakase.write_story }
  Then  { assert_file 'roro/containers/env/.keep' }
  And   { assert_file 'roro/containers/scripts/.keep' }
  And   { assert_file 'roro/env/.keep' }
  And   { assert_file 'roro/keys/.keep' }
  And   { assert_file 'roro/scripts/.keep' }
end
