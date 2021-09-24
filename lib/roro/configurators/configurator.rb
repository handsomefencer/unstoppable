# frozen_string_literal: true

module Roro
  module Configurators
    class Configurator

      attr_reader :structure, :env, :options, :story, :itinerary, :manifest

      def initialize(options = {} )
        @options = options ? options : {}
        @structure = StructureBuilder.build
        @catalog = options[:catalog] || CatalogBuilder.build
        validate_catalog
        choose_adventure
        build_manifest
      end

      def validate_catalog
        Validator.new(@catalog)
      end

      def choose_adventure
        adventure = AdventureChooser.new(@catalog)
        @itinerary = adventure.itinerary
      end

      def build_manifest(catalog = nil )
        ## get catalog
        # get itineraries
        # for each itinerary
        # get yaml_files
        # split catalog from itinerary to get itinerary path
        # split itinerary paht into array like %w[fatsufodo stories python]
        # get story files for catalog path
        # recurse build_manifest(#{catalog_path}/#array.shift, array)
        catalog   ||= @catalog
        @manifest ||= []
        case
        when catalog_is_parent?(catalog)
          catalog
        when catalog_is_story?(catalog)
          @manifest << catalog
        end
        @itinerary.each do |itinerary|
          build_manifest(itinerary)
        end
      end


    #   def merge_stories(files)
    #     files.each { |f| @structure.merge!(read_yaml(f)) if f.match?('.yml') }
    #   end
    #
    #   def merge_story(file)
    #     content = read_yaml(file)
    #     [:actions].each do |key|
    #       content[key].each do |item|
    #         @structure[key] = @structure[key] << item
    #       end
    #     end
    #     @structure = content
    #   end
    #
    #   def roll_child_story(location)
    #     case
    #     when child_is_yaml?(location)
    #       merge_story(location)
    #     when child_is_template?(location)
    #       return
    #     when child_is_dotfile?(location)
    #       return
    #     when child_is_inflection?(location)
    #       answer = choose_plot(location)
    #       roll_child_story("#{location}/#{answer}")
    #     when child_is_empty?(location)
    #       return
    #     when get_children(location).size > 0
    #       get_children(location).each { |child| roll_child_story(child) }
    #     end
    #     @structure
    #   end
    end
  end
end
