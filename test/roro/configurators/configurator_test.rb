# frozen_string_literal: true

require 'test_helper'

describe Configurator do
  Given(:options)    { {} }
  Given(:config)     { Configurator.new() }
  Given(:adventures) { %w[ fatsufodo django ] }

  Given { stubs_adventure("#{Roro::CLI
                               .stacks}/unstoppable/developer_styles/fatsufodo/frameworks/django") }

  context 'without options' do
#
#     describe '#initialize' do
#       Given { skip }
#       Then { assert_match 'lib/roro/stacks', config.stack }
#       And  { assert_equal Hash, config.structure.class }
#     end
#
#     describe '#validate_stack' do
#       Given { skip }
#       Then { assert_nil config.validate_stack }
#     end
#
#     describe '#choose_adventure' do
#       Given { skp }
#       Given { config.choose_adventure }
#
#       context 'when fatsufodo' do
#         context 'when django' do
#           When(:adventures) { %w[ fatsufodo django ] }
#           # focus
#           # Then {
#           #   # assert_file_match_in 'frameworks/django', config.itinerary }
#         end
#
#         context 'when wordpress' do
#           When(:adventures) { %w[ fatsufodo wordpress ] }
#           # Then { assert_file_match_in 'frameworks/wordpress', config.itinerary }
#         end
#
#         context 'when rails' do
#           When(:adventures) { %w[ fatsufodo rails ] }
#           # Then { assert_file_match_in 'frameworks/rails', config.itinerary }
#         end
#       end
#     end
#   end
#
#   context 'when stack path' do
#     Given(:options) { { stack: stack_path } }
#
#     describe '#initialize' do
#       Given { skip }
#       Then { assert_match 'stack/valid', config.stack }
#     end
#
#     describe '#validate_stack' do
#       Given { skip }
#       Then { assert_nil config.validate_stack }
#     end
  end
end
