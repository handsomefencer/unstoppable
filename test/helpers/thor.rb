module TestHelper
  module Files
    module Assertions

      def prepare_destination(test_app=nil)
        Dir.chdir(ENV.fetch("PWD") + '/tmp')
        unless test_app.nil?
          temp_name = test_app.split('/').last
          FileUtils.rm_rf(test_app.split('/').last)
          FileUtils.cp_r("../test/dummies/#{test_app}", ".")
          Dir.chdir(temp_name)
        end
      end
      
      def roro_environments 
        %w(development production test staging ci)
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
        Roro::CLI.source_root
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
