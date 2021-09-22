module Roro
  class CLI < Thor

    desc 'rollon', 'Roll a fresh development story into the current directory.'
    map 'rollon' => 'rollon'

    def rollon
      configurator = Configurator.new
    end
  end
end
