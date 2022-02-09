# frozen_string_literal: true

require 'thor'
require 'openssl'
require 'base64'
require 'yaml'
require 'roro/cli'
require 'roro/cli/generate/generate'
require 'roro/cli/generate/generate_annotations'
require 'roro/cli/generate/generate_adventure'
require 'roro/cli/generate/generate_containers'
require 'roro/cli/generate/generate_environments'
require 'roro/cli/generate/generate_exposed'
require 'roro/cli/generate/generate_keys'
require 'roro/cli/generate/generate_mise'
require 'roro/cli/generate/generate_obfuscated'
require 'roro/cli/rollon'
require 'roro/common/file_reflection'
require 'roro/common/utilities'
require 'roro/configurators/adventure_case_builder'
require 'roro/configurators/adventure_chooser'
require 'roro/configurators/adventure_picker'
require 'roro/configurators/adventure_writer'
require 'roro/configurators/catalog_builder'
require 'roro/configurators/configurator'
require 'roro/configurators/dependency_satisfier'
require 'roro/configurators/question_asker'
require 'roro/configurators/question_builder'
require 'roro/configurators/reflector'
require 'roro/configurators/structure_builder'
require 'roro/configurators/validator'
require 'roro/crypto/cipher'
require 'roro/crypto/exposer'
require 'roro/crypto/file_writer'
require 'roro/crypto/key_writer'
require 'roro/crypto/obfuscator'
require 'roro/error'
require 'roro/version'

module Roro

  def self.gem_root
    File.dirname __dir__
  end

  include Roro::Configurators
  class CLI < Thor
    include Utilities
    include FileReflection
  end

  module FileReflection; end
  module Utilities; end

  module Crypto
    include FileReflection
    class Cipher; end
    class QuestionAsker < Thor; end
    class CatalogBuilder; end
  end
  module Configurators
    include Utilities
  end
end
