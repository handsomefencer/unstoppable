require "thor"
require "roro/version"
require "roro/cli"
require "roro/configurator"
require "roro/crypto"

module Roro
  module Crypto 
    class KeyError < StandardError; end
    class SourceDirectoryError < StandardError; end
    class DataDestructionError < StandardError; end
  end 

  
  class Error < StandardError; end
end
