require "test_helper"

describe Roro::Crypto::FileWriter do
  before { prepare_destination 'crypto' }
  
  Given(:subject)   { Roro::Crypto::FileWriter.new }
  
  describe ":write_to_file(data, filename)" do
    Given(:destination) { './roro/example.txt' }
    Given { subject.write_to_file(destination, 'export FOO=bar')  }
  
    Then { assert_file destination, 'export FOO=bar' }
  end
end