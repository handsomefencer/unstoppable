# frozen_string_literal: true

require 'thor'
require 'openssl'
require 'base64'
require 'roro/error'
require 'roro/cli'
require 'roro/configurator'
require 'roro/crypto'

module Roro
  class CLI < Thor; end

  module Crypto; end

  module Configurators
    class Configurator; end
    class QuestionAsker < Thor; end
    class CatalogBuilder; end

    module Utilities; end


  end
end
