# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator

      attr_reader :structure, :itinerary, :manifest, :actions

      def initialize(options = {} )
        @options   = options ? options : {}
        @catalog   = options[:catalog] || CatalogBuilder.build
        @structure = StructureBuilder.build
        @manifest  = []
        validate_catalog
      end

      def validate_catalog
        Validator.new(@catalog)
      end

      def choose_adventure
        adventure = AdventureChooser.new
        @itinerary = adventure.build_itinerary(@catalog)
      end

      def build_manifest(itinerary = nil, catalog = @catalog, trail = nil)
        itinerary ||= @itinerary
        @manifest += catalog_stories(catalog)
        if itinerary.is_a?(Array)
          itinerary.each { |i| build_manifest(i) }
        elsif !trail&.empty?
          trail ||= itinerary.split("#{@catalog}/").last.split('/')
          args = [itinerary, "#{catalog}/#{trail.shift}", trail ]
          build_manifest(*args)
        end
      end

      def build_actions
        @actions ||= []
        manifest.each do |manifest|
          actions = read_yaml(manifest)[:actions]
          @actions += actions if actions
        end
      end
    end
  end
end
