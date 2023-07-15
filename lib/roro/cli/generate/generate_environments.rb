# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:environments', 'Generate environment files and keys'
    map 'generate:environments' => 'generate_environments'

    def generate_environments(*args)
      hash = args.pop if args.last.is_a?(Hash)
      mise = Roro::CLI.mise
      environments = args.empty? ? Roro::CLI.roro_environments : args
      containers = Dir.glob("./#{mise}/containers/*").select { |f| File.directory?(f) }
      create_file "./#{mise}/env/.keep", ''
      environments.each do |env|
        generate_environment_file(env, hash, mise, containers)
      end
    end

    desc 'generate:environment_files', 'Generate environment files and keys'
    map 'generate:environment_files' => 'generate_environment_files'

    def generate_environment_files(hash, location = 'mise')
      content = []
      hash.each do |key, value|
        next unless value.is_a?(Hash)

        array = []

        value.each do |foo, bar|
          if bar.keys.include?(:value) || bar.keys.include?(:name)
            array << "#{foo}=#{bar[:value]}"
          else
            generate_environment_files({ key => bar }, [location, 'containers', foo].join('/'))
          end
        end
        create_file("#{location}/env/#{key}.env", array.join("\n"), force: true) unless array.empty?
      end
    end

    no_commands do
      def generate_environment_file(env, hash, mise, containers)
        content = hash&.dig(env.to_sym)&.sort&.each&.map do |key, value|
                    "#{key}=#{value[:value]}" if value.is_a?(Hash)
                  end&.join("\n") || 'SOME_KEY=some_value'
        create_file("./#{mise}/env/#{env}.env", content, force: true)
        containers.each do |container|
          create_file("#{container}/env/#{env}.env", content, force: true)
        end
      end
    end
  end
end
