require 'thor'
require 'roro/cli/base'
<<<<<<< HEAD
require 'roro/cli/dockerize'
=======
require 'roro/cli/rollon'
>>>>>>> dummy
require 'roro/cli/greenfield'

module Roro
  class CLI < Thor

    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + '/cli/templates'
    end
  end
end
