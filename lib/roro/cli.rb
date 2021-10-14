# frozen_string_literal: true

require_relative 'cli/rollon'
require_relative 'cli/generate/generate_containers'
require_relative 'cli/generate/generate_environments'
require_relative 'cli/generate/generate_exposed'
require_relative 'cli/generate/generate_keys'
require_relative 'cli/generate/generate_obfuscated'

module Roro
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      "#{@template_root || File.dirname(__FILE__)}/templates"
    end

    def self.catalog_root
      "#{File.dirname(__FILE__)}/stacks/catalog/unstoppable/developer_styles"
    end

    def self.roro_environments
      %w[base development production test staging ci]
    end
  end
end
