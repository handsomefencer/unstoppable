require "test_helper"

describe Roro::CLI do

  Given { rollon_rails_test_base }
  Given(:cli) { Roro::CLI.new }
  describe ".config_std_out" do 
      
    Given { cli.config_std_out_true }
    Given(:file) { 'config/boot.rb'}
    Given(:insertion) { "$stdout.sync = true" }
    
    Then { assert_insertion }
  end
  
  describe '.gitignore_sensitive_files' do 

    Given(:file) { '.gitignore' }
    Given(:insertions) { [ /roro\/\*\*\/\*.key/, 
      /roro\/\*\*\/\*.env/,
      /\*kubeconfig.yaml/,
      /\*kubeconfig.yml/,
      /\*.roro_configurator.yml/
    ] }
    
    When { cli.gitignore_sensitive_files }
    
    Then { assert_insertions }
  end
end
