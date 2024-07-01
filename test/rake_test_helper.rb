# frozen_string_literal: true

require 'test_helper'

class Minitest::Spec
  include RakeTaskTestHelper

  before do
    check_into_workbench
  end

  after do
    check_out_of_workbench
  end
end