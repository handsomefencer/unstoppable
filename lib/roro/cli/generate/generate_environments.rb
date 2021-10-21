# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:environments', 'Generate environment files and keys'
    map 'generate:environments'  => 'generate_environments'

    def generate_environments(*args)
      if args.last.is_a?(Hash)
        hash = args.pop
      end
      default_environments = Roro::CLI.roro_environments
      mise = Roro::CLI.mise
      environments = args.empty? ? default_environments : args
      containers = Dir.glob("./#{mise}/containers/*").select { |f| File.directory?(f) }
      environments.each do |env|
        content = hash&.dig(env.to_sym)&.each&.map {|k,v| "#{k}=#{v[:value]}"}&.join("\n") || 'SOME_KEY=some_value'
        create_file "./#{mise}/env/#{env}.env", content
        containers.each do |container|
          create_file "#{container}/env/#{env}.env", content
        end
      end
    end
  end
end
