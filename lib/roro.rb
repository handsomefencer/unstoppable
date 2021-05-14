require "thor"
require "roro/version"
require "roro/cli"
require "roro/configurator"
require "roro/crypto"
require "roro/crypto/cipher"

module Roro
  module Crypto 
    class KeyError < StandardError; end
    class EnvironmentError < StandardError; end
    class DataDestructionError < StandardError; end
    class EncryptableError < StandardError; end
    class DecryptableError < StandardError; end
  end 

  
  class Error < StandardError; end
end
