module Roro 
  class CLI < Thor 
       
    desc "rollon::ruby_gem::with_ci_cd", "Generate files for containerized gem testing, CircleCI, and releasing to RubyGems."
    map "rollon::ruby_gem::with_ci_cd" => "rollon_ruby_gem_with_ci_cd"

    def rollon_ruby_gem_with_ci_cd(*args) 
      ruby_gem_with_ci_cd(*args)
      configure_for_rollon
    end
    
    no_commands do 
      def ruby_gem_with_ci_cd(*args)
        answer = ask("\nYou can add your rubygems api key in\n\t 
          './roro/containers/ruby_gem/ci.smart.env' \n\nlater, or we'll try to add it here:",
        default: '')
        rubygems_api_key = (answer.eql?("") ? 'some-key' : answer)
        @config.env[:rubygems_api_key] = rubygems_api_key
        @config.env[:rubies] = [] 
        3.times do |index| 
          newruby = @config.env[:ruby_version].gsub('.', '').to_i - index
          @config.env[:rubies] << newruby.to_s.split('').join('.')
        end
        directory 'ruby_gem/roro', './roro', @config.env
        directory 'ruby_gem/.circleci', './.circleci', @config.env
        copy_file 'ruby_gem/preface-returns-array_of_strings.yml', './preface-returns-array_of_strings.yml'
        
        @config.env[:rubies].each do |ruby| 
          file = '.circleci/config.yml'
          spacer = "\n      - run: "
          rv = "RUBY_VERSION=#{ruby} docker-compose "
          build = "build ruby_gem"
          up = "up -d --force-recreate ruby_gem"
          run_tests = "run ruby_gem bundle exec rake test"
          append_to_file file, spacer + rv + run_tests, after: "- placeholder"
          append_to_file file, spacer + rv + up, after: "- placeholder"
          append_to_file file, spacer + rv + build, after: "- placeholder"
        end
        gsub_file '.circleci/config.yml', "- placeholder", "- checkout"
        append_to_file ".gitignore", "\nGemfile.lock"
        gitignore_sensitive_files
      end
    end
  end
end
