# require "test_helper"

# describe Roro::CLI do

#   Given { greenfield_rails_test_base }

#   Given(:config) { Roro::Configuration.new }
#   Given(:cli)     { Roro::CLI.new }
#   # Given(:rollon)      { 
#   #   cli.instance_variable_set(:@config, config)
#   #   cli.rollon_rails
#   # Given(:rollon)      { 
#   #   cli.instance_variable_set(:@config, config)
#   #   cli.rollon_rails
#   # }
  
#   describe "generate:config:rails" do
        
#     Given { cli.generate_config_story }
    
#     # describe "after greenfielding, before rolling on" do 
    
#       Given(:file) { '.roro_configurator.yml' }
#       Given(:lines) { [ 
#         "app_name: '603'", 
#         "database_vendor: postgresql"  ]}
      
#       Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } } }
#     # end
#   end
# end