require 'roro/cli/rollon/stories/ruby_gem/with_ci_cd.rb'
# class RubyGem
#   attr_reader :getsome
  
#   def initialize
#     @getsome = 'getsome'    
#   end
# end

# include Stories::RubyGem
# module Rollon 
#   module Story 
    
#   end
# end
# class Rollon::Story::RubyGem < Roro::CLI
#   attr_reader :getsome
#   def initialize
#     @getsome = 'getsome'    
#   end
# end

# # module Roro

# #   class CLI < Thor

    
# #     no_commands do
      
# #       def ruby_gem(*args) 
        
        
# #       end
# #       def copy_ruby_gem_files
# #         copy_file 'ruby_gem/config.yml', '.circleci/config.yml'
# #       end
# #     end
    
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
