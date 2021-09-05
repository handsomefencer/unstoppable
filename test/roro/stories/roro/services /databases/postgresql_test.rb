# require 'test_helper'
#
# describe Roro::CLI do
#   before { skip }
#
#   Given { rollon_rails_test_base }
#   Given(:cli)     { Roro::CLI.new }
#   Given(:rollon)  { cli.rollon(options) }
#   Given(:config)  { cli.instance_variable_get("@config" ) }
#   Given(:options) { { story: { rails: [
#     { database: :postgresql },
#     { ci_cd:    :circleci }
#   ] } } }
#
#   Given { rollon }
#
#   describe 'must add pg gem in gemfile' do
#
#     Given(:file)      { 'Gemfile' }
#     Given(:insertion) { "gem 'pg'"}
#
#     Then { assert_insertion }
#   end
#
#   describe "config/database.yml" do
#
#     Given(:file) { 'config/database.yml' }
#     Given(:insertions) { [
#       "<%= ENV.fetch('DATABASE_HOST') %>",
#       "<%= ENV.fetch('POSTGRES_USERNAME') %>",
#       "<%= ENV.fetch('POSTGRES_PASSWORD') %>",
#       "<%= ENV.fetch('POSTGRES_DATABASE') %>"
#     ] }
#
#     Then { assert_insertions }
#   end
#
#   describe 'env_files' do
#
#     Given(:file)         { "roro/containers/database/#{config.env[:env]}.smart.env" }
#     Given(:environments) { Roro::CLI.roro_environments }
#     Given(:insertions)   { [
#       "POSTGRES_USERNAME=postgres",
#       "POSTGRES_PASSWORD=your-postgres-password",
#       "POSTGRES_DATABASE=#{config.env[:main_app_name]}_#{config.env[:env]}_db",
#       "RAILS_ENV=#{config.env[:env]}"
#     ] }
#
#     Then { assert_insertions_in_environments }
#   end
#
#   describe 'preface-returns-array_of_strings.yml' do
#
#     Given(:file) { "preface-returns-array_of_strings.yml" }
#     Given(:insertion) {
#       yaml_from_template('rails/database/with_postgresql/_service.yml')}
#
#     Then { assert_insertion }
#   end
# end
