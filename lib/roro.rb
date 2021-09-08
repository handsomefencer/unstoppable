# frozen_string_literal: true

require 'require_all'

require 'thor'
require 'openssl'
require 'base64'
require_rel '../lib'

module Roro
  class CLI < Thor; end

  module Crypto; end

  module Configurator; end
end
