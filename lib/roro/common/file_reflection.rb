# frozen_string_literal: true

module Roro
  module FileReflection

    def source_files(dir, pattern)

      Dir.glob("#{dir}/**/*#{pattern}")
    end

    def gather_environments(dir, ext)
      environments = source_files(dir, ext).map do |file|
        file.split('/').last.split('.').first
      end
      if environments.empty?
        raise Roro::Error, "No #{ext} files in #{dir}"
      else
        environments.uniq
      end
    end

    def get_key(environment, _dir = Roro::CLI.mise)
      env_key = "#{environment.upcase}_KEY"
      key_file = Dir.glob("#{Roro::CLI.mise}/keys/#{environment}.key").first
      if ENV[env_key]
        ENV[env_key]
      elsif key_file
        File.read(key_file).strip
      else
        raise Roro::Error, "No #{env_key} set. Please set one as a variable or in a file."
      end
    end
  end
end
