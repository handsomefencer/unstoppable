module Roro

  class CLI < Thor
    
    desc "greenfield::rails", "Greenfield a new, dockerized rails app with
    either MySQL or PostgreSQL in a separate container."
  
    map "greenfield::rails" => "greenfield_rails"
    
    def greenfield_rails
      greenfield( { story: :rails } )
    end
  end
end
