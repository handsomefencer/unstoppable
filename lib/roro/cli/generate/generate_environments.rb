# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:environments', 'Generate environment files and keys'
    map 'generate:environments' => 'generate_environments'

    def generate_environments(*args)
      hash = args.pop if args.last.is_a?(Hash)
      default_environments = Roro::CLI.roro_environments
      mise = Roro::CLI.mise
      environments = args.empty? ? default_environments : args
      containers = Dir.glob("./#{mise}/containers/*").select { |f| File.directory?(f) }
      create_file "./#{mise}/env/.keep", ''
      environments.each do |env|
        content = hash&.dig(env.to_sym)&.sort&.each&.map do |k, v|
                    "#{k}=#{v[:value]}"
                  end&.join("\n") || 'SOME_KEY=some_value'
        create_file "./#{mise}/env/#{env}.env", content
        containers.each do |container|
          create_file "#{container}/env/#{env}.env", content
        end
      end
    end
  end
end
