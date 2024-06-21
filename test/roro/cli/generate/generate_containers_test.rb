# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_containers' do
Given { skip }
  Given(:workbench)    { 'workbench' }
  Given(:default_apps) { %w[backend database frontend] }
  Given(:containers)   { nil }
  Given(:generate) { Roro::CLI.new.generate_containers(*containers) }
  Given { quiet { generate } }

  describe 'when non-directory sibling exists in workbench' do
    Given { insert_dummy_env 'dummy.env' }
    Then  { refute_file 'roro/containers/dummy' }
  end

  context 'when no sibling folders and when' do
    context 'no containers supplied must generate default containers' do
      Then  { assert_directory 'roro/containers/backend/scripts' }
      And   { assert_directory 'roro/containers/database/env' }
      And   { assert_directory 'roro/containers/frontend/scripts' }
    end

    context 'containers supplied must generate specified containers' do
      When(:containers) { %w[pistil stamen database] }
      Then  { assert_directory 'roro/containers/database/scripts' }
      And   { assert_directory 'roro/containers/pistil/scripts' }
      And   { assert_directory 'roro/containers/stamen/scripts' }
    end
  end
end
