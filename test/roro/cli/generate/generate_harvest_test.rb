# # frozen_string_literal: true

# require 'test_helper'

# describe 'Roro::CLI#generate_harvest' do
#   Given { skip }
#   Given(:workbench) { 'harvest' }
#   Given(:generate) { Roro::CLI.new.generate_harvest }
#   Given { quiet { generate } }

#   describe 'must generate .harvest directory' do
#     Then { assert_directory '.harvest' }

#     describe 'with correct .yml files' do
#       Then { assert_file '.harvest/cases.yml' }
#       And { assert_file '.harvest/structure_choices.yml' }
#       And { assert_file '.harvest/structure_human.yml' }
#     end
#   end
# end
