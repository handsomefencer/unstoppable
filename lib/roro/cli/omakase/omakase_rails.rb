module Roro

  class CLI < Thor

    desc 'omakase::rails', "Greenfield a dockerized rails backend."

    map 'omakase::rails' => 'greenfield_rails'

    def greenfield_rails
      greenfield( { story: :rails } )
    end
  end
end
