# frozen_string_literal: true

module Roro
  class CLI < Thor
    method_option :environments,
                 type: :array,
                 aliases: :e,
                 banner: 'one, two, three',
                 desc: 'The environments to generate:',
                 default: Roro::CLI.roro_environments

    method_option :containers,
                 type: :array,
                 aliases: :c,
                 banner: 'container_one, container_two, container_three',
                 default: Roro::CLI.roro_default_containers,
                 desc: 'The containers to generate:'

    method_option :mise_en_place,
                 type: :string,
                 aliases: :m,
                 default: 'mise',
                 desc: "The name of your mise en place folder. This is where your container folders, environment files, scripts, and keys will live"

    method_option :keys,
                 type: :array,
                 aliases: :k,
                 banner: 'one.key two.key three.key',
                 default: Roro::CLI.roro_environments,
                 desc: 'The names of your keys to generate. If none supplied, Roro will infer them from your .env files:'

    desc 'generate', 'Generate stuff.'
    map 'generate'  => 'generate'

    def generate
      order = %w[mise_en_place containers environments keys]
      order.each do |item|
        value = options[item]
        case item
        when 'mise_en_place'
          generate_mise(value)
        when 'containers'
          generate_containers(*value)
        when 'environments'
          generate_environments(*value)
        when 'keys'
          generate_keys(*value)
        end
      end
    end
  end
end
