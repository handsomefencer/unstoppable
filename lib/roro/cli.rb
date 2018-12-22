require 'thor'
require 'roro/cli/dockerize'
# require 'roro/cli/dockerize'
# require 'handsome_fencer/circle_c_i/cli/generate_key'
# require 'handsome_fencer/circle_c_i/cli/obfuscate'
# require 'handsome_fencer/circle_c_i/cli/expose'

module Roro
  class CLI < Thor

    def self.source_root
      File.dirname(__FILE__) + '/cli/templates/'
    end
  end
end
