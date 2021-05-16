require "thor"
require "roro/version"
require "roro/cli"
require "roro/configurator"
require "roro/crypto"
require "roro/crypto/file_reflection"
require "roro/crypto/file_writer"
require "roro/crypto/cipher"
require "roro/crypto/key_writer"
require "roro/crypto/obfuscator"
require "roro/crypto/exposer"

module Roro
  class Error < StandardError; end
  
  module Crypto 
    class KeyError             < Roro::Error; end
    class EnvironmentError     < StandardError; end
    class DataDestructionError < StandardError; end
    class EncryptableError     < StandardError; end
    class DecryptableError     < StandardError; end
  end 
end
