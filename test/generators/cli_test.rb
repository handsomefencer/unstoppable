require 'thor_test_helper'
require 'minitest/autorun'
describe "HandsomeFencer::CircleCI::CLI" do

  Given(:subject) { HandsomeFencer::CircleCI::CLI.new }
#
#   Given { prepare_destination }
#   Given { subject.dockerize }
#
#   describe "dockerize" do
#     #
#     # Then { assert_file '.circleci' }
#     # And { assert_file '.circleci/config.yml' }
#     # And { assert_file '.circleci/config.yml.workflow-example' }
#     # And { assert_file 'docker' }
#     # And { assert_file 'docker/containers' }
#     # And { assert_file 'docker/containers/app' }
#     # And { assert_file 'docker/containers/app/Dockerfile' }
#     # And { assert_file 'docker/containers/app/development.env' }
#     # And { assert_file 'docker/containers/app/production.env' }
#     # And { assert_file 'docker/containers/database' }
#     # And { assert_file 'docker/containers/database/development.env' }
#     # And { assert_file 'docker/containers/database/production.env' }
#     # And { assert_file 'docker/containers/web' }
#     # And { assert_file 'docker/containers/web/app.conf' }
#     # And { assert_file 'docker/containers/web/Dockerfile' }
#     # And { assert_file 'docker/containers/web/production.env' }
#     # And { assert_file 'docker/env_files' }
#     # And { assert_file 'docker/env_files/circleci.env' }
#     # And { assert_file 'docker/keys' }
#     # And { assert_file 'docker/overrides' }
#     # And { assert_file 'docker/overrides/production.docker-compose.yml' }
#
#     # And { refute File.exist? 'config/database.yml' }
#     # And { refute File.exist? 'Gemfile' }
#     # And { refute File.exist? 'Gemfile.lock' }
#     # And { refute Fiel.exist? 'lib/tasks/deploy.rake' }
#   end
#
#   describe "generate_key" do
#
#     Given { subject.generate_key('circleci') }
#
#     Then { assert_file 'docker/keys/circleci.key' }
#   end
#
#   describe "obfuscate" do
#
#     Then { refute File.exist? 'docker/keys/circleci.key' }
#
#     describe "with ENV['CIRCLE_KEY'] set" do
#
#       Given(:passkey) { "HidqS1dbAZXFDGiWGGk3Zw==" }
#       Given { ENV['CIRCLECI_KEY'] = passkey }
#       Given { subject.obfuscate('circleci') }
#
#       Then { assert_file 'docker/env_files/circleci.env.enc' }
#     end
#
#     describe "ENV['CIRCLE_KEY'] = nil " do
#
#       Given { ENV['CIRCLECI_KEY'] = nil }
#       Given { assert ENV['CIRCLECI_KEY'].nil? }
#
#       describe "without dkfile" do
#
#         Given { refute File.exist? '.circleci/keys/circleci.key' }
#
#         describe "must raise error" do
#
#           Given(:error) { HandsomeFencer::CircleCI::Crypto::DeployKeyError }
#
#           Then { assert_raises(error) { subject.obfuscate('circleci') } }
#         end
#       end
#
#       describe "with dkfile" do
#
#         Given { subject.generate_key('circleci') }
#         Given { subject.obfuscate('circleci') }
#
#         Then { assert_file 'docker/env_files/circleci.env.enc' }
#
#         describe "expose" do
#
#           Given { File.delete('docker/env_files/circleci.env') }
#           Given { subject.expose('circleci') }
#
#           Then { assert_file 'docker/env_files/circleci.env' }
#         end
#       end
#     end
#
#     describe "development" do
#
#       Given { File.delete 'docker/keys/development.key'}
#       Given { refute File.exist? 'docker/keys/development.key'}
#       Given { refute File.exist? 'docker/containers/app/development.env.enc' }
#       Given { subject.generate_key('development') }
#       Given { subject.obfuscate('development') }
#
#       Then { assert_file 'docker/containers/database/development.env.enc' }
#
#       describe "expose" do
#
#         Given { File.delete 'docker/containers/database/development.env' }
#         Given { refute File.exist? 'docker/containers/database/development.env' }
#         Given { subject.expose('development') }
#
#         Then { assert File.exist? 'docker/containers/database/development.env' }
#       end
#     end
  # end
end
