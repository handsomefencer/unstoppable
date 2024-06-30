# frozen_string_literal: true

require 'stack_test_helper'

describe 'Roro::Crypto::Exposer.new' do
  Given(:subject)   { Roro::Crypto::Exposer.new }
  Given(:workbench) { 'active/mise' }
  # Given(:workbench) { 'active/roro' }
  Given(:directory) { './roro' }
  Given(:directory) { './mise' }
  Given(:env)       { 'dummy' }
  Given(:envs)      { [env] }
  Given(:key)       { dummy_key }

  Given { insert_dummy_key 'dummy.key', './mise/keys' }
  Given { insert_dummy_env_enc('mise/env/dummy.env.enc')  }
  Given { insert_dummy_env_enc('mise/containers/roro/env/dummy.env.enc')  }

  Invariant do
    assert_file 'mise/keys/dummy.key'
    assert_file 'mise/env/dummy.env.enc'
    assert_file 'mise/containers/roro/env/dummy.env.enc'
  end

  describe '#expose_file(file, key)' do
    Given { subject.expose_file('mise/env/dummy.env.enc', key) }
    Given { subject.expose_file('mise/containers/roro/env/dummy.env.enc', key) }
    Then do
      assert_file 'mise/env/dummy.env'
      assert_file 'mise/containers/roro/env/dummy.env'
    end
  end

  describe '#expose(envs, dir, ext)' do
    Given(:execute) { subject.expose envs, directory, 'env.enc' }

    Then do
      execute
      assert_file 'mise/env/dummy.env'
      # assert_file 'mise/containers/roro/env/dummy.env'
    end
  end
end
