require "test_helper"

describe Roro::Crypto::File::Writer do
  before(:all) { prepare_destination 'workbench' }
  
  Given(:subject)   { Roro::Crypto::File::Writer.new }
  
  describe ":write_to_file(data, filename)" do
    Given(:content)     { 'export FOO=bar' }
    Given(:destination) { './roro/example.txt' }
    Given { subject.write_to_file(destination, content)  }
  
    Then { assert_equal File.read(destination), content }
  end
end