require 'roro/configurator/eligibility'
require 'roro/configurator/okonomi'
require 'roro/configurator/omakase'
require 'roro/configurator/receiver'

module Roro 
  module Configurator 
    include Eligibility
    include Receiver
    include Okonomi
    include Omakase
  end
  
  class Configuration < Thor
    include Roro::Configurator
  end
end