namespace :ci do
  namespace :config do
    desc 'Validate .circleci/config.yml'
    task 'process' do |t|
      puts "Creating process.yml"
      system("circleci config process .circleci/config.yml > process.yml")
      puts "Created process.yml"
    end
  end
end


