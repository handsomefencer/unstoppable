# frozen_string_literal: true

module Roro
  class CLI < Thor
    desc 'generate:environments', 'Generate environment files and keys'
    map 'generate:environments'  => 'generate_environments'

    def generate_environments(*environments)
      default_environments = Roro::CLI.roro_environments
      mise = Roro::CLI.mise
      environments = environments.empty? ? default_environments : environments
      containers = Dir.glob("./#{mise}/containers/*").select { |f| File.directory?(f) }
      (environments.empty? ? default_environments : environments).each do |env|
        content = 'SOME_KEY=some_value'
        create_file "./#{mise}/env/#{env}.env", content
        containers.each do |container|
          create_file "#{container}/env/#{env}.env", content
        end
      end
      environments.each { |e| generate_keys(e) }
    end
  end
end
