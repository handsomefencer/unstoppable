
module Roro
  module Test 
    module Helpers 
      module FilesHelper

        def prepare_destination(dummy)
          Dir.chdir ENV['PWD']
          tmpdir = Dir.mktmpdir
          FileUtils.cp_r(Dir.pwd + "/test/dummies/#{dummy}", tmpdir)
          Dir.chdir(tmpdir + '/' + dummy)
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
          src = [ENV.fetch("PWD"), 'test/fixtures/files', src].join('/')
          FileUtils.cp(src, dest)
        end
  
        def insert_dotenv(filename)
          src = 'rails/dotenv/database.pg.env.tt'
          insert_file src, filename
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

        def assert_insertion 
          assert_file(file) { |c| assert_match( insertion, c ) } 
        end
        
        def assert_insertions 
          insertions.each { |l| assert_file(file, insertions) } 
        end
        
        def assert_insertions_in_environments
          environments.each { |env| 
            config.env[:env] = env
            insertions.each { |insertion| 
              assert_file(file) { |c| 
                assert_match(insertion,c)
              }
            }
          }
        end
     
        def assert_removals 
          removals.each { |l| assert_file(file) { |c| refute_match(l,c)}}
        end

        def insert_dummy_encryptable(filename='./roro/dummy.env') 
          insert_file 'dummy_env', filename
        end
        
        def insert_dummy_decryptable(filename='./roro/dummy.env.enc') 
          insert_file 'dummy_env_enc', filename 
        end
        
        def insert_dummy(filename='./roro/dummy.env')
          insert_file 'dummy_env', filename
        end
        
        def insert_key_file(filename='dummy.key')
          insert_file 'dummy_key', "./roro/keys/#{filename}"
        end
          
        def assert_correct_error
          returned = assert_raises(error) { execute }
          assert_match error_message, returned.message 
        end 
      end
    end
  end
end