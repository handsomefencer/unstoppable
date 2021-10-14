# frozen_string_literal: true

require 'thor'
require 'openssl'
require 'base64'
require 'yaml'
require 'roro/error'
require 'roro/cli'
require 'roro/common/file_reflection'
require 'roro/configurator'
require 'roro/crypto'
require 'roro/version'

module Roro

  class CLI < Thor; end

  module FileReflection; end
  module Crypto; end

  module Configurators
    include Utilities

    class Configurator; end
    class QuestionAsker < Thor; end
    class CatalogBuilder; end

    module Utilities; end


  end
end
