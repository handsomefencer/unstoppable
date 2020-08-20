require 'thor'
require 'roro/cli/base/base'
require 'roro/cli/rollon'
require 'roro/cli/greenfield'
require 'roro/cli/obfuscate'
require 'roro/cli/expose'
require 'roro/cli/ruby_gem'
require 'roro/cli/generate/config/rails'
require 'roro/cli/generate/config'
require 'roro/cli/generate/generate_keys'
require 'roro/cli/configuration'

module Roro
  
  class CLI < Thor

    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + '/cli/templates'
    end
  end
end
