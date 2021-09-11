# frozen_string_literal: true

module Roro
  module Configurators
    module Utilities

      def get_children(location)
        Dir.glob("#{location}/*")
      end

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

      def sentence_from(array)
        array[1] ? "#{array[0..-2].join(', ')} and #{array[-1]}" : array[0]
      end

      def read_yaml(yaml_file)
        JSON.parse(YAML.load_file(yaml_file).to_json, symbolize_names: true)
      end

      def catalog_is_node?(catalog)
        get_children(catalog).any? { |w| w.include? '.yml' }
      end

      def catalog_is_story?(catalog)
        %w[yml yaml].include?(story_name(catalog).split('.').last)
      end

      def catalog_is_inflection?(catalog)
        catalog_stories(catalog).empty?
      end

      def catalog_stories(catalog)
        Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
      end

      def node_missing?(node)
        !File.exists?(node)
      end

      def node_empty?(node)
        Dir.glob("#{node}/**").empty?
      end

      def node_is_file?(node)
        File.file?(node)
      end

      def node_exists?(node)

      end

      def catalog_is_node?(catalog)
        get_children(catalog).any? { |w| w.include? '.yml' }
      end

      def catalog_is_story?(catalog)
        %w[yml yaml].include?(story_name(catalog).split('.').last)
      end

      def catalog_is_inflection?(catalog)
        catalog_stories(catalog).empty?
      end

      def node_missing?(node)
        !File.exists?(node)
      end

      def node_empty?(node)
        Dir.glob("#{node}/**").empty?
      end

      def node_is_file?(node)
        File.file?(node)
      end

      def node_exists?(node)

      end

      def story_name(catalog)
        catalog.split('/').last
      end


      def story_name(catalog)
        catalog.split('/').last
      end

    end
  end
end
