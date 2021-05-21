# frozen_string_literal: true

require_rel 'configurator/eligibility'
require_rel 'configurator/okonomi'
require_rel 'configurator/omakase'

module Roro
  module Configurator
    include Eligibility
    include Okonomi
    include Omakase
    class Configurator < Thor; end
  end

  class Configuration < Thor
    include Roro::Configurator
  end
end
