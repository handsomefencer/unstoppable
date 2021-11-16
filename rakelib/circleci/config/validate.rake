namespace :circleci do
  namespace :config do
    desc 'Validate .circleci/config.yml'
    task 'validate' do |t|
      puts 'Validating .circleci/config.yaml ...'
      system("circleci config validate")
    end
  end
end



