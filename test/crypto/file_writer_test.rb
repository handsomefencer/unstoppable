require "test_helper"

describe Roro::Crypto::FileWriter do
  let(:workbench) { 'crypto/roro' }
  let(:subject)   { Roro::Crypto::FileWriter.new }
  
  describe ":write_to_file(data, filename)" do
    let(:destination) { 'roro/example.txt' }

    Given { subject.write_to_file(destination, 'export FOO=bar')  }
    Then  { assert_file destination, 'export FOO=bar' }
  end
end