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
      siblings = Dir.entries('./') - %w[roro . ..]
      containers = siblings.empty? ? %w[frontend backend database] : siblings
      containers.each do |container|
        create_file("./roro/containers/#{container}/scripts/.keep")
        environments.each do |env|
          dummy_env_var = 'SOME_KEY=some_value'
          create_file("./roro/env/#{env}.env", dummy_env_var)
          create_file "./roro/containers/#{container}/env/#{env}.env", dummy_env_var
        end
      end
      environments.each { |e| generate_keys(e) }
    end
  end
end
