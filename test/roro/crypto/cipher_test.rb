# frozen_string_literal: true

require 'test_helper'

describe 'Roro::Crypto::Cipher' do
  let(:cipher)    { Roro::Crypto::Cipher.new }
  let(:key)       { cipher.generate_key }
  let(:plaintext) { 'The Quick Brown Fox' }
  let(:encrypted) { cipher.encrypt(plaintext, key) }
  let(:decrypted) { cipher.decrypt(encrypted, key) }

  describe '#generate_key' do
    Then { assert_equal key.size, 25 }
  end

  describe '#encrypt(decrypted, key)' do
    Then { assert_equal encrypted.class, String }
    And  { assert_match '=', encrypted }
  end

  describe '#decrypt(encrypted, key)' do
    Then { assert_equal decrypted, plaintext }
    And  { refute_equal 'The slow gray fox', plaintext }
  end
end
