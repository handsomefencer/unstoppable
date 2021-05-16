require_rel 'configurator/eligibility'
require_rel 'configurator/okonomi'
require_rel 'configurator/omakase'

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