require "test_helper"

describe Roro::Configuration::Okonomi do
  before { skip }
  Given { #  prepare_destination 'omakase/omakase' }
  Given { stubs_dependency_responses }

  Given(:config)  { Roro::Configuration.new(options) }
  Given(:options) { nil }
  Given(:question)  { config.structure[:choices][:config_std_out_true]}
  Given(:intention) { config.structure[:intentions][:config_std_out_true] } 
  
  describe '.okonomi' do
    describe 'when called with .ask_question must return answer' do 
  
      Given { Thor::Shell::Basic.any_instance.stubs(:ask)
        .with(
          question[:question], 
          default: question[:default], 
          limited_to: question[:choices].keys
        ).returns('n') 
      }
      
      Then { assert_equal 'n', config.ask_question(question) }
    end
    
    describe 'when called with .ask_questions must change intention' do 

      Given { Thor::Shell::Basic.any_instance.stubs(:ask).returns('n') }
      Given { config.ask_questions }
      
      Then  { assert_equal 'n', intention }
    end
    
    describe 'when called with .new with :okonomi option' do 
      
      Given { Thor::Shell::Basic.any_instance.stubs(:ask).returns('n') }
      Given(:options) { { "okonomi" => "okonomi" } }
      
      Then  { assert_equal 'n', intention }
    end
  end
end