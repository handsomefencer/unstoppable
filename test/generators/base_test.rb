require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination 'dummy' }

  describe ":configurate" do

    describe "without argument" do

      Then { subject.configurate['APP_NAME'].must_equal "sooperdooper"}
    end

    describe "with" do

      describe "env_vars: {}" do
        
        Given { subject.options = { "env_vars" => {
          'APP_NAME' => "strawberry_field_app",
          'DOCKERHUB_EMAIL' => "user@test.org" } } }

        Then {
          subject.configurate['APP_NAME'].must_equal "strawberry_field_app"
          subject.configurate['DOCKERHUB_EMAIL'].must_equal "user@test.org" }
      end
    end
  end
end
