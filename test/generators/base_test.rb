# require "test_helper"
# require "generators/shared_expectations"
#
# describe Roro::CLI do
#
#   Given(:subject) { Roro::CLI.new }
#
#   Given { prepare_destination }
#
#   describe ":configurate" do
#
#     describe "without argument" do
#
#       Then { subject.configurate['APP_NAME'].must_equal "sooperdooper"}
#     end
#
#     describe "with" do
#
#       describe "env_vars: {}" do
#         # roro greenfield:
#         #   {"env_vars"=>{}}
#         # roro greenfield --interactive
#         #   {"env_vars"=>{}, "interactive"=>"interactive"}
#         # roro greenfield --interactive --env_vars sweet:log
#         #   {"env_vars"=>{"sweet"=>"log"}, "interactive"=>"interactive"}
#         Given { subject.options = { "env_vars" => {
#           'APP_NAME' => "strawberry_field_app",
#           'DOCKERHUB_EMAIL' => "user@test.org" } } }
#
#         Then {
#           subject.configurate['APP_NAME'].must_equal "strawberry_field_app"
#           subject.configurate['DOCKERHUB_EMAIL'].must_equal "user@test.org" }
#       end
#     end
#   end
# end
