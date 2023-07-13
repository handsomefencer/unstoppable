# frozen_string_literal: true

require_relative '../shared_tests'

describe '2: unstoppable_rails_style: omakase' do
  Given(:workbench) {}

  Given do
    debuggerer
    rollon(__dir__)
  end

  Then do
    assert_stacked_stacks
    assert_stacked_sqlite
    assert_stacked_7_0
    refute_stacked_compose_service_redis
    refute_stacked_compose_service_sidekiq
  end
  focus
  describe 'system tests' do
    Then do
      assert_file('Gemfile', /# gem ["']webdrivers["']/)
      assert_file('test/application_system_test_case.rb', /browser: :remote/)
      assert_file('test/test_helper.rb', /Capybara.server_host = ['"]0.0.0.0['"]/)
      assert_file('test/test_helper.rb', /Capybara.app_host = /)
      a = ['docker-compose.yml', :services, :'chrome-server']
      assert_yaml(*a, :image, %r{selenium/standalone-chrome:96.0})
      assert_yaml(*a, :ports, 0, "7900:7900")
    end
  end
end
