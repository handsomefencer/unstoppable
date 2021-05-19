module Roro

  class CLI < Thor

    desc 'omakase::rails', "Greenfield a new, dockerized rails app with
    either MySQL or PostgreSQL in a separate container."

    map 'omakase::rails' => 'greenfield_rails'

    def greenfield_rails
      greenfield( { story: :rails } )
    end
  end
end
