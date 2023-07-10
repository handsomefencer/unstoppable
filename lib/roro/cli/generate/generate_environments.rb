# frozen_string_literal: true

module Roro
  ## getsome
  class CLI < Thor
    desc 'generate:environments', 'Generate environment files and keys'
    map 'generate:environments' => 'generate_environments'

    def generate_environments(*args)
      hash = args.pop if args.last.is_a?(Hash)
      default_environments = Roro::CLI.roro_environments
      mise = Roro::CLI.mise
      environments = args.empty? ? Roro::CLI.roro_environments : args
      containers = Dir.glob("./#{mise}/containers/*").select { |f| File.directory?(f) }
      create_file "./#{mise}/env/.keep", ''
      environments.each do |env|
        generate_environment_file(env, hash, mise, containers)
      end
    end

    def generate_environment_files(hash, location = 'mise')
      content = []
      array = []
      hash.each do |key, variables|
        next unless Roro::CLI.roro_environments.include?(key.to_s)

        variables.each do |foo, bar|
          next if foo.eql?(:app)

          begin
            if bar.is_a?(Hash)
              array << "#{foo}=#{bar[:value]}"
            elsif bar.is_a?(Array)
              bar.each do |baz|
                smegma = {
                  key => baz
                }
                generate_environment_files(smegma, [location, 'containers', foo].join('/'))
              end
            end
          rescue StandardError
            byebug
          end
        end
        create_file("#{location}/env/#{key}.env", array.join("\n")) unless array.empty?
      end
    end

    no_commands do
      def generate_environment_file(env, hash, mise, containers)
        content = hash&.dig(env.to_sym)&.sort&.each&.map do |key, value|
                    "#{key}=#{value[:value]}" if value.is_a?(Hash)
                  end&.join("\n") || 'SOME_KEY=some_value'
        create_file "./#{mise}/env/#{env}.env", content
        containers.each do |container|
          create_file "#{container}/env/#{env}.env", content
        end
      end
    end
  end
end
