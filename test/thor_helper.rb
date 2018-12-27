module TestHelper
  module Files
    module Assertions

      def prepare_destination
        gem_root = Gem::Specification.find_by_name('roro').gem_dir
        Dir.chdir File.join(gem_root, 'tmp')
      end

      def assert_file(file, *contents)
        assert File.exist?(file), "Expected #{file} to exist, but does not"

        read = File.read(file) if block_given? || !contents.empty?
        yield read if block_given?
        contents.each do |content|

          case content
          when String
            assert_equal content, read
          when Regexp
            assert_match content, read
          end
        end
      end

      alias :assert_directory :assert_file

      def assert_no_file(relative)
        absolute = File.expand_path(relative, destination_root)
        assert !File.exist?(absolute), "Expected file #{relative.inspect} to not exist, but does"
      end
      alias :assert_no_directory :assert_no_file

      def assert_migration(relative, *contents, &block)
        file_name = migration_file_name(relative)
        assert file_name, "Expected migration #{relative} to exist, but was not found"
        assert_file file_name, *contents, &block
      end

      def assert_no_migration(relative)
        file_name = migration_file_name(relative)
        assert_nil file_name, "Expected migration #{relative} to not exist, but found #{file_name}"
      end

      def assert_class_method(method, content, &block)
        assert_instance_method "self.#{method}", content, &block
      end

      def assert_instance_method(method, content)
        assert content =~ /(\s+)def #{method}(\(.+\))?(.*?)\n\1end/m, "Expected to have method #{method}"
        yield $3.strip if block_given?
      end
      alias :assert_method :assert_instance_method

      def assert_field_type(attribute_type, field_type)
        assert_equal(field_type, create_generated_attribute(attribute_type).field_type)
      end

      def assert_field_default_value(attribute_type, value)
        if value.nil?
          assert_nil(create_generated_attribute(attribute_type).default)
        else
          assert_equal(value, create_generated_attribute(attribute_type).default)
        end
      end
    end
  end
end
