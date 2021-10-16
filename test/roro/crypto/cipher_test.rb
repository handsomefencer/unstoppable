# frozen_string_literal: true

require 'test_helper'

describe 'Roro::Crypto::Cipher' do
  Given(:cipher)    { Roro::Crypto::Cipher.new }
  Given(:key)       { cipher.generate_key }
  Given(:plaintext) { 'The Quick Brown Fox' }
  Given(:encrypted) { cipher.encrypt(plaintext, key) }
  Given(:decrypted) { cipher.decrypt(encrypted, key) }

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
