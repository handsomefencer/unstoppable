# frozen_string_literal: true

require_relative '../shared_tests'

describe '1 okonomi -> 4 sqlite -> 2 7_0 -> 2 vite -> 1 none' do
  Given(:workbench) {}
  
  Given do 
    rollon(__dir__) 
  end 
end
