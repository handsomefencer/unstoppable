# require "test_helper"

# describe Roro::CLI do
# Given { skip }  
#   Given(:subject) { Roro::CLI.new }
#   Given { prepare_destination "rails/603" }
  
#   describe "generate:config:roro" do
    
#     Given { subject.configure_for_greenfielding }
#     Given { subject.generate_config }
    
#     describe "after greenfielding, before rolling on" do 
    
#       Given(:file) { '.roro_config.yml' }
#       Given(:lines) { [ "app_name: '603'", "database_vendor: postgresql"  ]}
      
#       Then { assert_file(file) { |c| lines.each { |l| assert_match l, c } } }
#     end
#   end
# end