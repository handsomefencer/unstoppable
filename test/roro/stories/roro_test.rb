# frozen_string_literal: true

require 'test_helper'

describe 'Stories: Roro' do
  let(:workbench) { nil }
  let(:subject) { Omakase }
  let(:options) { nil }
  let(:omakase) { subject.new(options) }
  let(:plot_root) { "#{Dir.pwd}/lib/roro/stories/roro" }
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
  focus
  # Then { assert_equal Dir.glob(Dir.pwd + '/**/*'), 'blah'}


end
