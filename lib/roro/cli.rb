# frozen_string_literal: true

require_relative 'cli/rollon'
require_relative 'cli/generate/generate_containers'
require_relative 'cli/generate/generate_environments'
require_relative 'cli/generate/generate_exposed'
require_relative 'cli/generate/generate_keys'
require_relative 'cli/generate/generate_mise'
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

    def self.mise_location
      lookup = Dir.glob("#{Dir.pwd}/**/*.roro")&.first&.split("#{Dir.pwd}/")
      if lookup
        mise = lookup.last.split('/').first
      else
        mise = 'roro'
      end
      "#{Dir.pwd}/#{mise}"
    end

    def self.mise
      mise_location.split("#{Dir.pwd}/").last
    end

    def self.roro_environments
      %w[base development production test staging ci]
    end

    def self.stack_documentation_root
      '<a href="url">link text</a>'
    end

    def self.roro_default_containers
      %w[backend database frontend]
    end
  end
end
