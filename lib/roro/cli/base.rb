require_relative 'base/base'

module Roro

  class CLI < Thor
    
    no_commands do
      
      include Configuration 
      include ContinuousIntegration 
      include Utilities
      include Insertions
      include InsertGems
      include BaseFiles
    end
  end
end
