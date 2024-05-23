# frozen_string_literal: true

require 'test_helper'

describe '6 tailwind -> 4 SQLite -> 4 Vite -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    rollon(__dir__)
  end

  Then { assert_correct_manifest(__dir__) }

  describe 'entrypoint must be configured with tailwind' do
      # Given(:file) { 'app/javascript/entrypoints/application.css' }
      # Then { assert_file file, /tailwind.css/ }
  end

  describe 'must have correct docker-compose watch-js service' do
    Given(:file) { 'docker-compose.development.yml' }
  end
end
