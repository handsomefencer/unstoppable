module Roro 
  class CLI < Thor 
       
    desc "rollon::ruby_gem::with_ci_cd", "Generate files for containerized gem testing, CircleCI, and releasing to RubyGems."
    method_option :rubies, type: :array, banner: "2.5.3 2.4.2"
    map "rollon::ruby_gem::with_ci_cd" => "rollon_ruby_gem_with_ci_cd"

    def rollon_ruby_gem_with_ci_cd(*args) 
      ruby_gem_with_ci_cd(*args)
    end
    
    no_commands do 
      def ruby_gem_with_ci_cd(*args)
        configure_for_rollon
        answer = ask("\nYou can add your rubygems api key in\n\t 
          './roro/ci.env' \n\nlater, or we'll try to add it here:", 
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
          img_name = 'ruby_gem:' + ruby
          file = '.circleci/config.yml'
          
          run_build = "\n      - run: RUBY_IMAGE=ruby:#{ruby}-alpine docker-compose build ruby_gem"
          run_test = "\n      - run: RUBY_IMAGE=ruby:#{ruby}-alpine docker-compose run ruby_gem rake test"
          append_to_file file, run_build + run_test, after: 'gem install roro'
        end
        append_to_file ".gitignore", "\nGemfile.lock"
        gitignore_sensitive_files
      end
    end
  end
end
# #     def ruby_gem
# #       rubies = options["rubies"] || ["2.5.3", "2.6.0"]
# #       copy_file 'ruby_gem/docker-compose.yml', 'docker-compose.yml'
# #       copy_file 'ruby_gem/config.yml', '.circleci/config.yml'
# #       copy_file 'ruby_gem/setup-gem-credentials.sh', '.circleci/setup-gem-credentials.sh'
# #       directory 'ruby_gem/docker', 'docker', { ruby_version: "2.5"}

# #       rubies.each do |ruby|
# #         rubydash = ruby.gsub('.', '-')
# #         rubyunderscore = ruby.gsub('.', '_')
# #         doc_loc = "docker/containers/#{rubyunderscore}/Dockerfile"
# #         content = <<-EOM

# #   app-#{rubydash}:
# #     build:
# #       context: .
# #       dockerfile: #{doc_loc}
# #     command: rake test
# #         EOM
# #         append_to_file 'docker-compose.yml', content
# #         template 'ruby_gem/docker/containers/app/Dockerfile.tt', doc_loc, {ruby_version: ruby}
# #         # append_to_file 'docker-compose.yml', "\n  app-#{ruby}:\n    build:\n\s\s\s\s\s\scontext:"
# #       end

# #       # end
# # #       <<EOF
# # #    This is the first way of creating
# # #    here document ie. multiple line string.
# # # EOF
# #       # %w[app web].each do |container|
# #       #   options = {
# #       #     email: @env_hash['DOCKERHUB_EMAIL'],
# #       #     app_name: @env_hash['APP_NAME'] }
# #       #
# #       #   template("docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options)
# #       # end
# #     end
# #   end
# # end
