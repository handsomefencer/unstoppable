require 'roro/configurator/eligibility'
require 'roro/configurator/okonomi'
require 'roro/configurator/omakase'

module Roro 
  module Configurator 
    include Eligibility
    include Okonomi
    include Omakase
  end
  
  class Configuration < Thor
    include Roro::Configurator
  end
end