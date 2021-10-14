
module Roro
  module Crypto 
    class Cipher

      def initialize(options = {})
        @standard = options[:standard] || 'AES-128-CBC' 
        @salt     = options[:salt]     || '8 octets' 
        @cipher   = OpenSSL::Cipher.new @standard
      end

      def generate_key
        Base64.encode64(@cipher.random_key)
      end

      def encrypt(decrypted, key)
        build_cipher(key)
        Base64.encode64(@cipher.update(decrypted) + @cipher.final)
      end

      def decrypt(encrypted, key)
        build_cipher(key)
        @cipher.decrypt.pkcs5_keyivgen @key, @salt
        @cipher.update(Base64.decode64 encrypted) + @cipher.final
      end
      
      private
      
      def build_cipher(key)
        @cipher.encrypt.pkcs5_keyivgen @key=key, @salt
      end
    end 
  end 
end