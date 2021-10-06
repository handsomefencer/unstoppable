require "test_helper"

describe 'Roro::CLI#rollon' do
  let(:rollon) { roro_rollon }

  context 'when fatsufodo django' do
    let(:adventures) { %w[fatsufodo django] }
    let(:overrides)  { %w[] }

    context 'when default vfffariables' do
      Given { rollon }
      Then  { assert_file 'unstoppadble_django/Dockerfile', /python:3/ }
      And   { assert_file 'unstoppable_django/docker-compose.yml', /=password/ }
    end

    context 'when overrides variables' do
      When(:overrides) { %w[3.2 y y newpass] }
      Given { rollon }
      Then  { assert_file 'unstoppable_django/Dockerfile', /python:3.2/ }
      And   { assert_file 'unstoppable_django/docker-compose.yml', /=newpass/ }
    end
  end
end
