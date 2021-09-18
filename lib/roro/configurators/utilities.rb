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
        Array.new(get_children(catalog).select { |c| catalog_is_story?(c) })
      end

      def choose_adventure(inflection)
        builder = QuestionBuilder.new(inflection: inflection)
        question = builder.question
        builder.answer_from(ask(question))
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

      def catalog_is_story_file?(catalog)
        File.file?(catalog)
      end

      def catalog_is_template?(catalog)
        catalog.split('/').last.match?('templates')
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

      def path_to_hash(path, array=nil)
        @path_hash ||= {}
        relpath = path.split(Dir.pwd).last
        array ||= relpath.split('/')
        # array.shift
        unless array.empty?
          array.shift
          item = array.shift
          @path_hash[item] = path_to_hash(path, array)
        end
        @path_hash # array.reverse { |assigned_value, key| { key => assigned_value } }
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
    end
  end
end
