require "thor"
require "roro/version"
require "roro/cli"
require "roro/configurator"
require "roro/crypto"
require "roro/crypto/cipher"
require "roro/crypto/key_manager"
require "roro/crypto/file/reflection"
require "roro/crypto/file/writer"

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
