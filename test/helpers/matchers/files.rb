module TestHelper
  module Matchers 
    module Files
      
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
      
      def refute_file(file, *contents)
        refute File.exist?(file), "Expected #{file} to not exist, but it does."
      end
    end 
  end
end