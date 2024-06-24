# frozen_string_literal: true

require 'stack_test_helper'

describe Roro::Crypto::FileWriter do
  Given(:subject)   { Roro::Crypto::FileWriter.new }
  Given(:workbench) { 'crypto/roro' }
  Given(:destination) { 'roro/example.txt' }

  describe ':write_to_file(data, filename)' do
    Given { quiet { subject.write_to_file(destination, 'export FOO=bar') } }
    Then  { assert_content destination, 'export FOO=bar' }
  end
end
