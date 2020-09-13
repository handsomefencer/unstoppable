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
      
      def remove_dot_env_files(envs, enc=nil)
        enc = enc ||= ''
        envs.each do |e|
          file = "/roro/containers/app/#{e}.env#{enc}"
          full = Dir.pwd + file 
          File.delete(Dir.pwd + file)  
        end
      end
      
      def insert_file(src, dest) 
        src = [Roro::CLI.source_root, src].join('/')
        FileUtils.cp(src, dest) 
      end

      def insert_dot_env_files(envs)
        src = 'rails/dotenv/database.pg.env.tt'
        envs.each do |e| 
          dest = "roro/containers/app/#{e}.env"
          envs.each { |e| insert_file src, dest } 
        end
      end

      def yaml_from_template(file)
        File.read([Roro::CLI.source_root, file].join('/'))
      end
    end 
  end
end