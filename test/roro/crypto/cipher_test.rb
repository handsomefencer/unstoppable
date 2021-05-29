# frozen_string_literal: true

require 'test_helper'

describe Roro::Crypto::Cipher do
  let(:subject)   { Roro::Crypto::Cipher.new }
  let(:key)       { subject.generate_key }
  let(:encrypted) { subject.encrypt(plaintext, key) }
  let(:decrypted) { subject.decrypt(encrypted, key) }
  let(:plaintext) { 'The Quick Brown Fox' }

  describe '#generate_key' do

    Then { assert_equal key.size, 25 }
  end

  describe '#encrypt(decrypted, key)' do

    Then { assert_equal encrypted.class, String }
    And  { assert_match '=', encrypted }
  end

  describe '#decrypt(encrypted, key)' do
    
    Then { assert_equal decrypted, plaintext }
  end
end
