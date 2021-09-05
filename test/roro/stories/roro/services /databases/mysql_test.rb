# require 'test_helper'
#
# describe Roro::CLI do
#   before { skip }
#   Given { rollon_rails_test_base }
#   Given(:cli)     { Roro::CLI.new }
#   Given(:rollon)  { cli.rollon(options) }
#   Given(:config)  { cli.instance_variable_get("@config" ) }
#   Given(:options) { { story: { rails: [
#     { database: :mysql },
#     { ci_cd:    :circleci }
#   ] } } }
#
#   Given { rollon }
#   describe '.rollon with mysql' do
#
#
#     describe 'must add mysql2 gem to gemfile' do
#
#       Given(:file)      { 'Gemfile' }
#       Given(:insertion) { "gem 'mysql2'"}
#
#       Then { assert_insertion }
#     end
#
#     describe "config/database.yml" do
#       Given(:file) { 'config/database.yml' }
#       Given(:insertions) { [
#         "<%= ENV.fetch('DATABASE_HOST') %>",
#         "<%= ENV.fetch('MYSQL_USERNAME') %>",
#         "<%= ENV.fetch('MYSQL_PASSWORD') %>",
#         "<%= ENV.fetch('MYSQL_DATABASE') %>",
#         "<%= ENV.fetch('MYSQL_DATABASE_PORT') %>"
#       ]}
#
#       Then { assert_insertions }
#     end
#
#     describe 'env_files' do
#
#       Given(:environments) { Roro::CLI.roro_environments }
#       Given(:file)         { "roro/containers/database/#{config.env[:env]}.smart.env" }
#       Given(:insertions)   { [
#         "MYSQL_ROOT_PASSWORD=root-mysql-password",
#         "MYSQL_PASSWORD=your-mysql-password",
#         "MYSQL_DATABASE=#{config.env[:main_app_name]}_#{config.env[:env]}_db",
#         "MYSQL_USERNAME=root",
#         "MYSQL_DATABASE_PORT=3306",
#         "RAILS_ENV=#{config.env[:env]}"
#       ] }
#
#       Then { assert_insertions_in_environments }
#     end
#
#     describe 'preface-returns-array_of_strings.yml' do
#
#       Given(:file) { "preface-returns-array_of_strings.yml" }
#       Given(:insertion) { yaml_from_template('rails/database/with_mysql/_service.yml')}
#
#       Then { assert_insertion }
#     end
#   end
# end
#
#
