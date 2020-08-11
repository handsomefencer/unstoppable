require_relative "base_test"

describe Roro::CLI do
  
  get_configuration
      
  describe ".config_std_out" do 
      
    Given { cli.config_std_out_true }
    
    Then do 
      assert_file 'config/boot.rb' do |c| 
        assert_match("$stdout.sync = true", c )
      end
    end
  end
  
  describe '.gitignore_sensitive_files' do 
    
    Given { cli.gitignore_sensitive_files }
    
    Then do 
      assert_file '.gitignore' do |c|
        assert_match /roro\/\*\*\/\*.key/, c
        assert_match /roro\/\*\*\/\*.env/, c
      end
    end
  end
end
