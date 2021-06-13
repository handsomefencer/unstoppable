# frozen_string_literal: true

module Roro
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      "#{File.dirname(__FILE__)}/templates"
    end

    def self.story_root
      "#{File.dirname(__FILE__)}/mise_en_place"
    end

    def self.test_fixture_root
      "#{File.dirname(__FILE__)}/test/fixtures"
    end

    def self.roro_environments
      %w[base development production test staging ci]
    end
  end
end
