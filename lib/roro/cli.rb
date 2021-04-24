
require 'roro/cli/generate/exposed'
require 'roro/cli/generate/keys'
require 'roro/cli/generate/obfuscated'
require 'roro/cli/generate/story'
require 'roro/cli/greenfield/rails'
require 'roro/cli/rollon'
require 'roro/cli/rollon/rails/base/base'
require 'roro/cli/rollon/rails/database/with_mysql'
require 'roro/cli/rollon/rails/database/with_postgresql'

require 'roro/cli/rollon/ruby_gem'

module Roro
  class CLI < Thor

    include Thor::Actions
    
    def self.source_root
      File.dirname(__FILE__) + '/templates'
    end
    
    def self.story_root
      File.dirname(__FILE__) + '/stories'
    end
    
    def self.test_fixture_root 
      File.dirname(__FILE__) + '/test/fixtures'
    end 
    
    def self.roro_environments 
      %w(development production test staging ci)
    end
  end
end
