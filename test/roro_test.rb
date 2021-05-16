require "test_helper"

describe Roro do
  it 'must have a version numbe' do 
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
