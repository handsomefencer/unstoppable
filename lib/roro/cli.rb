require 'roro/cli/base/base'
require 'roro/cli/base/base'
require 'roro/cli/configuration'
require 'roro/cli/generate/config/rails'
require 'roro/cli/generate/config'
require 'roro/cli/generate/exposed'
require 'roro/cli/generate/keys'
require 'roro/cli/generate/obfuscated'
require 'roro/cli/greenfield/stories/rails'
require 'roro/cli/rollon'
require 'roro/cli/rollon/stories'
require 'roro/cli/rollon/stories/ruby_gem'

module Roro
  
  class CLI < Thor

    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + '/cli/templates'
    end    
  end
end
