module Roro 
  class CLI < Thor 
       
    desc "rollon::ruby_gem::with_ci_cd", "Generate files for containerized gem testing, CircleCI, and releasing to RubyGems."
    map "rollon::ruby_gem::with_ci_cd" => "rollon_ruby_gem_with_ci_cd"

    def rollon_ruby_gem_with_ci_cd(*args) 
      ruby_gem_with_ci_cd(*args)
    end
    
    no_commands do 
      def ruby_gem_with_ci_cd(*args)
        configure_for_rollon
        answer = ask("\nYou can add your rubygems api key in\n\t 
          './roro/containers/ruby_gem/ci.env' \n\nlater, or we'll try to add it here:", 
        default: '')
        rubygems_api_key = (answer.eql?("") ? 'some-key' : answer)
        @config.app['rubygems_api_key'] = rubygems_api_key
        @config.app['rubies'] = [] 
        3.times do |index| 
          newruby = @config.app['ruby_version'].gsub('.', '').to_i - index
          @config.app['rubies'] << newruby.to_s.split('').join('.')
        end
        directory 'ruby_gem/roro', './roro', @config.app
        directory 'ruby_gem/.circleci', './.circleci', @config.app
        copy_file 'ruby_gem/docker-compose.yml', './docker-compose.yml'
        
        @config.app['rubies'].each do |ruby| 
          file = '.circleci/config.yml'
          spacer = "\n      - run: "
          rv = "RUBY_VERSION=#{ruby} "
          up_build = "docker-compose up --build ruby_gem"
          append_to_file file, spacer + rv + up_build, after: "- placeholder"
        end
        gsub_file '.circleci/config.yml', "- placeholder", "- checkout"
        append_to_file ".gitignore", "\nGemfile.lock"
        gitignore_sensitive_files
      end
    end
  end
end
