# frozen_string_literal: true

require 'stack_test_helper'

describe '6 tailwind -> 2 MySQL -> 3 Importmaps -> 1 okonomi' do
  Given(:workbench) {}

  Given do
    debuggerer
  end
focus
  Then { assert_correct_manifest(__dir__) }
end


# DATABASE_URL=postgres://localhost/rails_event_store_active_record?pool=5
# Example: mysql2://username:password@localhost/database_name
