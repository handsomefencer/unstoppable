module Roro

  class CLI < Thor

    desc 'omakase::rails', "Greenfield a dockerized rails backend."

    map 'omakase::rails' => 'greenfield_rails'

    def greenfield_rails
      greenfield( { story: :rails } )
    end

    desc 'omakase', 'get it'
    map 'omakase' => 'omakase'

    def omakase
      omakase = Roro::Configurators::Omakase.new
      omakase.choose_your_adventure
    end
  end
end
