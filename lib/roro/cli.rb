require 'thor'
require 'roro/cli/dockerize'

module Roro
  class CLI < Thor

    def self.source_root
      File.dirname(__FILE__) + '/cli/templates/'
    end
  end
end
