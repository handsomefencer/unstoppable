module TestHelper
  module Matchers
    module Crypto
      def insert_decryptable_file(filename='dummy') 
        insert_file 'dummy_env_enc', "#{directory}/#{filename}.env.enc"
      end
      
      def insert_encryptable_file(filename='dummy') 
        insert_file 'dummy_env', "#{directory}/#{filename}.env"
      end
      
      def insert_dummy(filename='dummy')
        insert_file 'dummy_env', "#{directory}/#{filename}#{extension}"
      end
      
      def insert_key_file(filename='dummy')
        insert_file 'dummy_key', "./roro/keys/#{filename}.key"
      end
        
      def assert_correct_error
        returned = assert_raises(error) { execute }
        assert_match error_message, returned.message 
      end 
      
      def assert_destruction_error 
        insert_dummy 
        assert_correct_error
      end
      
      def assert_correctly_written
        execute
        assert_equal File.read(file), content 
      end    
      
      def assert_correctly_sourced
        insert_dummy
        assert_includes execute, source_file 
      end 
      
      def assert_correctly_gathered 
        insert_dummy
        assert_equal ['dummy'], execute
      end
    
    end 
  end 
end