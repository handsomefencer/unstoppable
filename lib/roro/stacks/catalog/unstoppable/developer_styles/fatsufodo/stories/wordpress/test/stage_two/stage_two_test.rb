require "test_helper"

describe 'Roro::CLI#rollon' do
  let(:workbench) { }
  let(:cli) { Roro::CLI.new }
  let(:rollon)    {
    stub_adventure
    stub_overrides
    quiet { cli.rollon }
  }

  context 'when fatsufodo django' do
    let(:adventures) { %w[fatsufodo django] }
    let(:overrides)  { %w[] }

    context 'when default variables' do
      Given { rollon }
      Then  { assert_file 'unstoppable_django/Dockerfile', /python:3/ }
      And   { assert_file 'unstoppable_django/docker-compose.yml', /=password/ }
    end

    context 'when overrides variables' do
      When(:overrides) { %w[3.2 y y newpass] }
      Given { rollon }
      Then  { assert_file 'unstoppable_django/Dockerfile', /python:3.2/ }
      And   { assert_file 'unstoppable_django/docker-compose.yml', /=newpass/ }
    end



    context 'stage two' do
      When(:overrides) { %w[3.2 y y newpass] }
      # scribe SomeClass do
      #   it "should invoke right function" do
      #     mocked_method = MiniTest::Mock.new
      #     mocked_method.expect :call, return_value, []
      #     some_instance = SomeClass.new
      #     some_instance.stub :right, mocked_method do
      #       some_instance.invoke_function("right")
      #     end
      #     mocked_method.verify
      #   end
      # end
      Given {
        AdventureWriter
                .any_instance
                .expects(:eval)
                .once
      AdventureWriter
        .any_instance
        .expects(:eval)
        .with("system `DOCKER_BUILDKIT=1 docker build --file roro/containers/app/Dockerfile --output . .`")
        .once
      }
      # Given { AdventureWriter
      #   .any_instance
      #   .expects(:eval)
      #   .with("system `DOCKER_BUILDKIT=1 docker build --file roro/containers/app/Dockerfile --output . .`") }
      # Given {
      #   mock_method = MiniTest::Mock.new
      #   mock_method.expect :call, "return_value", []
      #   AdventureWriter.any_instance.stub :create_slug, mock_method do
      #     rollon
      #   end
      #   mock_method.verify
      # }
      focus
      Then  {
        rollon
        assert_file 'unstoppable_django/Dockerfile', /python:3.2/ }
    end
  end
end
