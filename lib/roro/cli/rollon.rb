module Roro
  class CLI < Thor

    desc 'rollon', 'Roll a fresh development story into the current directory.'
    map 'rollon' => 'rollon'

    def rollon
      configurator = Roro::Configurators::Configurator.new
      configurator.rollon
    end

    desc 'log itineraries', 'logs all possible itineraries in specified location'
    map 'log_itineraries' => 'log_itineraries'

    def log_itineraries(location = 'test/fixtures/itineraries')
      builder = Roro::Configurators::AdventureCaseBuilder.new
      builder.log_itineraries('test/fixtures/itineraries')
    end
  end
end
