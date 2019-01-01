$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "roro"
require "minitest/autorun"
require "minitest/spec"
require "minitest/given"
require "thor_helper"

include TestHelper::Files::Assertions

Minitest.after_run do
  prepare_destination
  # after do
  # $stdout = STDOUT
end

# end

# class Minitest::Test
# # before do
#   class Foo < StringIO
#     def puts s
#       super unless s.start_with?('[WARNING] Attempted to create command')
#     end
#   end
#   $stdout = Foo.new
# end
#
# # after do
#   # $stdout = STDOUT
# # end
#
# # end
