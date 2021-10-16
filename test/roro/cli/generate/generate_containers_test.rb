# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_containers' do
  Given(:subject)      { Roro::CLI.new }
  Given(:workbench)    { 'workbench' }
  Given(:default_apps) { %w[backend database frontend] }
  Given(:containers)   { nil }
  Given { quiet { subject.generate_containers(*containers) } }

  describe 'when non-directory sibling exists in workbench' do
    Given { insert_dummy_env 'dummy.env' }
    Then  { refute_file 'roro/containers/dummy' }
  end

  context 'when no sibling folders and when' do
    context 'no containers supplied must generate default containers' do
      When(:containers) { nil }
      Then  { assert_directory 'roro/containers/backend/scripts' }
      And   { assert_directory 'roro/containers/database/env' }
      And   { assert_directory 'roro/containers/frontend/scripts' }
    end

    context 'containers supplied must generate specified containers' do
      When(:containers) { %w[pistil stamen database] }
      Then  { assert_directory 'roro/containers/frontend/scripts' }
    end
  end

  context 'when sibling folders and' do
    Given(:workbench) { %w[roro pistil stamen] }

    context 'when no containers supplied must generate sibling containers' do
      When(:containers) { nil }
      Then  { assert_directory 'roro/containers/pistil/env' }
      And   { assert_directory 'roro/containers/pistil/scripts' }
      And   { assert_directory 'roro/containers/stamen/env' }
    end
  end
end
