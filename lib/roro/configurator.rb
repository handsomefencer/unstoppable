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
  
  class Configurator::Configuration < Thor::Shell::Basic
    include Roro::Configurator
  end
  
  class Configuration < Configurator::Configuration 
  end
end