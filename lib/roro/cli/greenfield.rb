module Roro

  class CLI < Thor
             
    desc "greenfield", "Greenfield a new app and roll it."

    def greenfield(args={})
      args[:greenfield] = true
      configure_for_rollon(args.merge(options))
      @config.structure[:greenfield_actions].each {|a| eval a }
      @config.structure[:greenfield_commands].each {|a| eval a }
    end
  end
end
