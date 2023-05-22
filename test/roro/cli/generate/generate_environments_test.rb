# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_environments' do
  Given(:workbench) { 'crypto/roro' }
  Given(:envs)      { nil }
  Given(:generate)  { Roro::CLI.new.generate_environments(*envs) }
  Given { quiet { generate } }

  context 'must generate default .env files' do
    describe 'for the project' do
      Then { assert_file 'roro/env/base.env' }
      And  { assert_file 'roro/env/production.env' }
      And  { assert_file 'roro/env/staging.env' }
      And  { assert_file 'roro/env/test.env' }
    end

    describe 'for each container' do
      Then { assert_file 'roro/containers/backend/env/base.env' }
      And  { assert_file 'roro/containers/backend/env/production.env' }
      And  { assert_file 'roro/containers/backend/env/staging.env' }
      And  { assert_file 'roro/containers/backend/env/test.env' }
    end
  end

  context 'when environments supplied must generate specified .env files' do
    When(:envs) { 'smart' }
    Then { assert_file 'roro/containers/frontend/env/smart.env' }
  end
end
