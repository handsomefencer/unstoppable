namespace :ci do
  namespace :prepare do 
    namespace :config do 
          
      desc 'Update circleci CLI tool'
      task 'update' do
        system("sudo -S CIRCLECI_CLI_TELEMETRY_OPTOUT=1 circleci update")
      end
    end
  end 
end