# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::FileWriter do
  let(:subject)   { Roro::Crypto::FileWriter.new }
  let(:workbench) { 'crypto/roro' }

  describe ':write_to_file(data, filename)' do
    let(:destination) { 'roro/example.txt' }

    Given { subject.write_to_file(destination, 'export FOO=bar') }
    Then  { assert_file destination, 'export FOO=bar' }
  end
end
