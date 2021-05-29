# frozen_string_literal: true

module Roro
  module Test
    module Helpers
      module FilesHelper



        def assert_file(file, *contents)
          actual = Dir.glob("#{Dir.pwd}/**/*")
          assert File.exist?(file), "Expected #{file} to exist, but does not. actual: #{actual}"

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
        alias assert_directory assert_file

        def refute_file(file, *_contents)
          refute File.exist?(file), "Expected #{file} to not exist, but it does."
        end

        def insert_file(source, destination)
          source = [ENV.fetch('PWD'), 'test/fixtures/files', source].join('/')
          destination = [Dir.pwd, destination].join('/')
          FileUtils.cp(source, destination)
        end

        def yaml_from_template(file)
          File.read([Roro::CLI.source_root, file].join('/'))
        end

        def assert_insertion
          assert_file(file) { |c| assert_match(insertion, c) }
        end

        def assert_insertions
          insertions.each { |_l| assert_file(file, insertions) }
        end

        def assert_insertions_in_environments
          environments.each do |env|
            config.env[:env] = env
            insertions.each do |insertion|
              assert_file(file) do |c|
                assert_match(insertion, c)
              end
            end
          end
        end

        def assert_removals
          removals.each { |l| assert_file(file) { |c| refute_match(l, c) } }
        end

        def insert_dummy_encryptable(filename = './roro/dummy.smart.env')
          insert_file 'dummy_env', filename
        end

        def insert_dummy_env(filename = './roro/dummy.smart.env')
          insert_file 'dummy_env', filename
        end

        def insert_dummy_env_enc(filename = 'roro/smart.env/dummy.smart.env.enc')
          insert_file 'dummy_env_enc', filename
        end

        def insert_dummy_decryptable(filename = './roro/dummy.smart.env.enc')
          insert_file 'dummy_env_enc', filename
        end

        def insert_dummy(filename = './roro/dummy.smart.env')
          insert_file 'dummy_env', filename
        end

        def insert_dummy_key(filename = 'dummy.key')
          insert_file 'dummy_key', "./roro/keys/#{filename}"
        end

        def dummy_key
          'XLF9IzZ4xQWrZo5Wshc5nw=='
        end
        def insert_key_file(filename = 'dummy.key')
          insert_file 'dummy_key', "./roro/keys/#{filename}"
        end

        def assert_correct_error
          returned = assert_raises(error) { execute }
          assert_match error_message, returned.message
        end

        def with_env_set(options = nil, &block)
          ClimateControl.modify(options || { DUMMY_KEY: var_from_ENV }, &block)
        end
      end
    end
  end
end
