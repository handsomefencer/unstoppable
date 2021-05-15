require "test_helper"

describe Roro::Crypto::Cipher do
  Given(:subject)   { Roro::Crypto::Cipher.new }
  Given(:key)       { subject.generate_key }
  Given(:plaintext) { 'The Quick Brown Fox' }
  Given(:encrypted) { subject.encrypt(plaintext, key) }
  Given(:decrypted) { subject.decrypt(encrypted, key) }


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