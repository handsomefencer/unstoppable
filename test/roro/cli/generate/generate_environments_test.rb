# frozen_string_literal: true

require 'test_helper'

describe 'Roro::CLI#generate_environments' do
  let(:subject)   { Roro::CLI.new }
  let(:workbench) { 'crypto/roro' }
  let(:envs)      { nil }
  let(:generate)  { suppress_output { subject.generate_environments(*envs) } }

  context 'no environments supplied must generate default .env files' do
    before { generate }

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
    Given { generate }
    Then  { assert_file 'roro/containers/frontend/env/smart.env' }
  end
end
