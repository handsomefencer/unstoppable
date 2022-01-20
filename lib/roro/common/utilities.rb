# frozen_string_literal: true
require 'json'
require 'yaml'

module Roro
  module Utilities

    def stack_type(stack)
      case
      when stack_not_present?(stack)
        :nonexistent
      when stack_is_ignored?(stack)
        :ignored
      when stack_is_dotfile?(stack)
        :dotfile
      when stack_is_storyfile?(stack)
        :storyfile
      when stack_is_templates?(stack)
        :templates
      when stack_is_inflection_stub?(stack)
        :inflection_stub
      when stack_is_inflection?(stack)
        :inflection
      when stack_is_stack?(stack)
        :stack
      when stack_is_story?(stack)
        :story
      end
    end

    def stack_is_stack?(stack)
      children(stack).any? do |c|
        stack_is_inflection?(c) || stack_is_story?(c)
      end
    end

    def stack_is_story?(stack)
      children(stack).any? { |c| story_name(stack).eql?(file_name(c)) }
    end

    def stack_is_file?(stack)
      File.file?(stack)
    end

    def stack_is_dotfile?(stack)
      stack_is_file?(stack) &&
        %w[keep gitkeep].include?(file_extension(stack))
    end

    def stack_is_storyfile?(stack)
      stack_is_file?(stack) &&
        %w[yml yaml].include?(file_extension(stack))
    end

    def stack_unpermitted?(stack)
      stack_is_file?(stack) &&
        !stack_is_storyfile?(stack) &&
        !stack_is_dotfile?(stack)
    end

    def stack_is_inflection_stub?(stack)
      return unless stack_is_inflection?(stack)
      choices = children(stack).select do |c|
        stack_is_inflection?(stack) &&
          !stack_is_stack?(stack) &&
          !stack_is_story?(stack) &&
          !stack_is_template?(stack) &&
          !stack_is_ignored?(stack) &&
          !stack_is_storyfile?(stack) &&
          stack_is_stack?(c) || stack_is_story?(c)
      end
      choices.size < 2
    end

    def stack_is_inflection?(stack)
      stack_stories(stack).empty? &&
        !File.file?(stack) &&
        !stack_is_ignored?(stack) &&
        !stack_is_templates?(stack)
    end

    def story_is_empty?(story)
      stack_is_storyfile?(story) &&
        !read_yaml(story)
    end

    def stack_not_present?(stack)
      !File.exist?(stack)
    end

    def stack_is_nil?(stack)
      !File.exist?(stack)
    end

    def stack_is_story_path?(stack)
      !stack_is_parent?(stack) &&
        !stack_is_templates?(stack) &&
        stack_is_node?(stack)
    end

    def stack_is_itinerary_path?(stack)
      !stack_is_parent?(stack) &&
        !stack_is_templates?(stack) &&
        stack_is_node?(stack)
    end

    def stack_is_parent?(stack)
      children(stack).any? { |c| stack_is_inflection?(c) }
    end

    def story_paths(stack)
      children(stack).select { |c| stack_is_story_path?(c) }
    end

    def stack_stories(stack)
      children(stack).select { |c| stack_is_storyfile?(c) }
    end

    def stack_is_templates?(stack)
      stack.split('/').last.match?('templates')
    end

    def stack_is_ignored?(stack)
      ignored = %w[test_dummy story_test test]
      ignored.include?(stack.split('/').last)
    end

    def all_inflections(stack)
      children(stack).select { |c| stack_is_inflection?(c) }
    end

    def children(stack)
      Dir.glob("#{stack}/*")
    end

    def stack_is_node?(stack)
      children(stack).any? { |w| w.include?('.yml') } && !stack_is_templates?(stack)
    end

    def stack_parent(stack)
      tree = stack.split('/')
      tree[-2]
    end

    def stack_parent_path(stack)
      stack.split("/#{name(stack)}").first
    end

    def stack_is_adventure?(stack)
      !stack_type(stack).eql?(:templates) &&
        stack_type(stack_parent_path(stack)).eql?(:inflection) &&
        [:stack, :story].include?(stack_type(stack))
    end

    def stack_is_empty?(stack)
      !stack_is_file?(stack) &&
        Dir.glob("#{stack}/**").empty?
    end

    def build_paths(stack, story_paths = nil)
      story_paths ||= []
      story_paths << stack if stack_is_story_path?(stack)
      children(stack).each { |c| build_paths(c, story_paths) }
      story_paths
    end

    def sort_hash_deeply(unsorted)
      sorted ||= {}
      unsorted.sort.to_h.map { |k, v| sorted[k] = sort_hash_deeply(v) }
      sorted
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

    def name(stack)
      stack.split('/').last
    end

    def file_name(story_file)
      story_file.split('/').last.split('.').first
    end

    def file_extension(file)
      file.split('.').last
    end

    def story_name(stack)
      stack.split('/').last
    end

    def sentence_from(array)
      array[1] ? "#{array[0..-2].join(', ')} and #{array[-1]}" : array[0]
    end

    def read_yaml(yaml_file)
      JSON.parse(YAML.load_file(yaml_file).to_json, symbolize_names: true)
    end

    def adventure_name(location)
      array = "Adventure #{stack_parent(location)} #{location.split(Roro::CLI.stacks).last}" #.split('/')
    end
  end
end
