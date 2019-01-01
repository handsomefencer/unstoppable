# require 'test_helper'
#
# describe "Roro::CLI" do
#
#   Given(:subject) { Roro::CLI.new }
#   Given { prepare_destination }
#   Given { Dir.chdir 'dummy_roro' }
#
#   Given { subject.generate_keys }
#
#   describe ":obfuscate(environment)" do
#
#     Given { refute_file 'docker/containers/app/development.env.enc' }
#     Given { assert_file 'docker/containers/app/production.env' }
#     Given { subject.obfuscate('development') }
#
#     Then {
#       assert_file 'docker/containers/app/development.env.enc'
#       assert_file 'docker/containers/web/development.env.enc' }
#
#     And {
#       refute_file 'docker/containers/app/production.env.enc'
#     }
#   end
#
#   describe ":obfuscate" do
#
#     Given { subject.obfuscate }
#
#     Then {
#       assert_file 'docker/containers/app/development.env.enc'
#       assert_file 'docker/containers/web/development.env.enc'
#       assert_file 'docker/containers/web/production.env.enc' }
#   end
# end
