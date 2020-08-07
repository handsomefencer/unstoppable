require_relative 'configuration.rb'
require_relative 'continuous_integration.rb'
require_relative 'utilities.rb'
require_relative 'insertions.rb'
require_relative 'insert_gems.rb'
require_relative 'copy_files.rb'

module Roro

  class CLI < Thor
    
    no_commands do
      
      include Configuration 
      include ContinuousIntegration 
      include Utilities
      include Insertions
      include InsertGems
      include CopyFiles
    end
  end
end
