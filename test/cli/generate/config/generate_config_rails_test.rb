# require "test_helper"

# describe Roro::CLI do

#   Given { prepare_destination 'rails/603' }
#   Given { stub_system_calls }

#   Given(:config) { Roro::Configuration.new }
  
#   Given(:cli)     { Roro::CLI.new }
#   Given(:rollon)      { 
#     cli.instance_variable_set(:@config, config)
#     cli.rollon_rails
#   }
  
#   describe "generate:config:rails" do
        
#     # Given { cli.generate_config }
    
#     # describe "after greenfielding, before rolling on" do 
    
#       Given(:file) { '.roro_configurator.yml' }
#       Given(:lines) { [ 
#         "app_name: '603'", 
#         "database_vendor: postgresql"  ]}
      
#       Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } } }
#     # end
#   end
# end