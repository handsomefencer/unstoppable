Capybara.server_host = '0.0.0.0'
Capybara.app_host = "http://#{ENV.fetch('HOSTNAME')}:#{Capybara.server_port}"
