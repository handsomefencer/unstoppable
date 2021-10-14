# frozen_string_literal: true

module Roro
  # Where all the generation, configuration, greenfielding happens.
  class CLI < Thor
    desc 'generate:containers', 'Generate containers.'
    map 'generate:containers' => 'generate_containers'

    def generate_containers(*containers)
      mise = Roro::CLI.mise
      default_containers = %w[frontend backend database]
      siblings = Dir.glob('./*').select do |f|
        File.directory?(f)
        !f.match?(mise)
      end
      siblings += default_containers if siblings.size.eql?(1)
      siblings.each { |s| s.split('/').last }.each do |container|
        create_file("#{mise}/containers/#{container}/scripts/.keep")
        create_file("#{mise}/containers/#{container}/env/.keep")
      end
    end
  end
end
