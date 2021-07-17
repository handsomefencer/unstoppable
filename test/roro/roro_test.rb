# frozen_string_literal: true

require "test_helper"

describe Roro do
  it 'must have a version number' do
    assert ::Roro::VERSION
  end

  it 'must include child modules' do
    assert_includes Roro.constants, :Error
    assert_includes Roro.constants, :CLI
    assert_includes Roro.constants, :Crypto
    assert_includes Roro.constants, :Configurator
    assert_includes Roro.constants, :VERSION
  end
end