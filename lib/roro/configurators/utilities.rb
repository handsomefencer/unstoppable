# frozen_string_literal: true

module Roro
  module Configurators
    module Utilities

      def sanitize(hash)
        (hash ||= {}).transform_keys!(&:to_sym).each do |key, value|
          case value
          when Array
            value.each { |vs| sanitize(vs) }
          when Hash
            sanitize(value)
          when true
            hash[key] = true
          when String || Symbol
            hash[key] = value.to_sym
          end
        end
      end

      def story_is_empty?
        content = read_yaml(@catalog)
        @content = content if content
        !content
      end

      def catalog_stories(catalog)
        get_children(catalog).select { |c| catalog_is_story?(c) }
      end

      def story_is_dotfile?
        %w[keep gitkeep].include?(@extension)
      end

      def story_has_unpermitted_extension?(extension)
        !(@permitted_extensions + %w[keep gitkeep]).include?(extension)
      end

      def sentence_from(array)
        array[1] ? "#{array[0..-2].join(', ')} and #{array[-1]}" : array[0]
      end

      def read_yaml(yaml_file)
        JSON.parse(YAML.load_file(yaml_file).to_json, symbolize_names: true)
      end

      def catalog_not_present?(catalog)
        !File.exist?(catalog)
      end

      def catalog_is_story_path?(catalog)
        !catalog_has_inflections?(catalog) &&
          !catalog_is_template?(catalog) &&
          catalog_is_node?(catalog)
      end

      def catalog_has_inflections?(catalog)
        get_children(catalog).any? { |c| catalog_is_inflection?(c) }
      end

      def catalog_is_parent?(catalog)
        get_children(catalog).any? { |c| catalog_is_inflection?(c) }
      end

      def story_paths(catalog)
        get_children(catalog).select { |c| catalog_is_story_path?(c) }
      end

      def catalog_is_story_file?(catalog)
        File.file?(catalog)
      end

      def catalog_is_template?(catalog)
        catalog.split('/').last.match?('templates')
      end

      def all_inflections(catalog)
        get_children(catalog).select { |c| catalog_is_inflection?(c) }
      end

      def get_children(location)
        Dir.glob("#{location}/*")
      end

      def catalog_is_node?(catalog)
        get_children(catalog).any? { |w| w.include?('.yml') } && !catalog_is_template?(catalog)
      end

      def catalog_parent(catalog)
        tree = catalog.split('/')
        tree[-2]
      end

      def catalog_parent_path(catalog)
        catalog.split("/#{name(catalog)}").first
      end

      def catalog_is_story?(catalog)
        %w[yml yaml].include?(story_name(catalog).split('.').last)
      end

      def catalog_is_file?(catalog)
        File.file?(catalog)
      end

      def catalog_is_inflection?(catalog)
        catalog_stories(catalog).empty? && !File.file?(catalog) && !catalog_is_template?(catalog)
      end

      def catalog_is_empty?(catalog)
        Dir.glob("#{catalog}/**").empty?
      end

      def story_name(catalog)
        catalog.split('/').last
      end

      def name(story_file)
        story_file.split('/').last.split('.').first
      end

      def build_paths(catalog, story_paths = nil)
        story_paths ||= []
        story_paths << catalog if catalog_is_story_path?(catalog)
        get_children(catalog).each { |c| build_paths(c, story_paths) }
        story_paths
      end
    end
  end
end
