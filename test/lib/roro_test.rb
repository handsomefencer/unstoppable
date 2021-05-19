require "test_helper"
# TODO refactor folders and files so they follow namespacing in roro/lib e.g test/lib/roro/cli_test.rb
#
describe Roro do
  it 'must have a version number' do
    assert ::Roro::VERSION
  end

  it 'must include child modules' do 
    actual = %w(Error CLI).to_set
    assert_includes Roro.constants, :Error
    assert_includes Roro.constants, :CLI
    assert_includes Roro.constants, :Crypto
    assert_includes Roro.constants, :Configurator
    assert_includes Roro.constants, :VERSION
  end
end