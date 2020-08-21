require "test_helper"

describe "Roro::Rollon::Story::RubyGem::WithCICD" do 

  Given(:subject) { RubyGem::WithCICD.new }

  Then do 
    assert_equal 'getsome', subject.getsome
  end
end
