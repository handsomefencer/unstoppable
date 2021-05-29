# frozen_string_literal: true

module Roro
  # Where all the generation, configuration, greenfielding happens.
  class CLI < Thor
    desc 'generate::environments', 'Generate environment files and keys'
    map 'generate::environments' => 'generate_environments'
    map 'generate:environments'  => 'generate_environments'

    def generate_environments(*environments)
      default_environments = %w[base development test staging production]
      environments = environments.empty? ? default_environments : environments
      siblings = Dir.glob('./*').select { |f| File.directory?(f) }
      siblings += %w[frontend backend database] if siblings.size.eql?(1)
      siblings.each { |s| s.split('/').last }.each do |container|
        create_file("roro/containers/#{container}/scripts/.keep")
        create_file("roro/containers/#{container}/env/.keep")
        environments.each do |env|
          content = 'SOME_KEY=some_value'
          create_file "./roro/env/#{env}.env", content
          create_file "roro/containers/#{container}/env/#{env}.env", content
        end
      end
      environments.each { |e| generate_keys(e) }
    end
  end
end
