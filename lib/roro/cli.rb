require 'thor'
require 'roro/cli/base'
require 'roro/cli/rollon'
require 'roro/cli/greenfield'
require 'roro/cli/generate_keys'

module Roro
  class CLI < Thor

    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + '/cli/templates'
    end
  end
end
