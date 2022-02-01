# frozen_string_literal: true

module Roro
  class CLI < Thor
    include Thor::Actions

    def self.supported_rubies
      %w[3.0 2.7 2.6]
    end

    def self.test_root
      "#{ENV['PWD']}/test"
    end

    def self.stacks
      "#{File.dirname(__FILE__)}/stacks"
    end

    def self.source_root
      "#{@template_root || File.dirname(__FILE__)}/templates"
    end

    def self.roro_root
      "#{File.dirname(__FILE__)}"
    end

    def self.dependency_root
      "#{self.roro_root}/dependencies"
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
