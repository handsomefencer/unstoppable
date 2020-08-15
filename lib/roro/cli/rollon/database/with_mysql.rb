# module Roro

#   class CLI < Thor

#     no_commands do
      
#       def configure_for_pg 
#         insert_pg_gem_into_gemfile
#         %w(development production test staging ci).each do |environment| 
#           @config.app['rails_env'] = environment
#           template(
#             'base/.env/web.env.tt',
#             "roro/containers/app/#{environment}.env", @config.app
#           )
#           template(
#             'base/.env/database.env.tt',
#             "roro/containers/database/#{environment}.env", @config.app
#           )
#         end
#         copy_file 'base/config/database.pg.yml', 'config/database.yml', force: true
#         service = [
#           "  database:",
#           "    image: postgres",
#           "    env_file:",
#           "      - roro/containers/database/development.env",
#           "    volumes:",
#           "      - db_data:/var/lib/postgresql/data"
#         ].join("\n")
        
#         @config.app[:database_service] = service
#       end
      
#       def configure_for_mysql 
#         insert_mysql_gem_into_gemfile
#         copy_file 'base/config/database.mysql.yml', 'config/database.yml', force: true
#         %w(development production test staging ci).each do |environment| 
#           byebug
#           @config.app[:rails_env] = environment
#           template(
#             'base/.env/web.env.tt',
#             "roro/containers/app/#{environment}.env", @config.app
#           )
#           template(
#             'base/.env/database.mysql.env.tt',
#             "roro/containers/database/#{environment}.env", @config.app
#           )
#         end
#         service = [
#           "  database:",
#           "    image: 'mysql:5.7'",
#           "    env_file:",
#           "      - roro/containers/database/development.env",
#           "      - roro/containers/app/development.env",
#           "    volumes:",
#           "      - db_data:/var/lib/mysql",
#           "    restart: always",
#           "    ports:",
#           "      - '3307:3306'"
#         ].join("\n")
        
#         @config.app[:database_service] = service
#       end
#     end
#   end
# end