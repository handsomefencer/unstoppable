# frozen_string_literal: true

require 'test_helper'

class Minitest::Spec

  before do
    check_into_workbench
  end

  after do
    check_out_of_workbench
  end
end
