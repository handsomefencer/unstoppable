desc 'Validate .circleci/config.yml'
task 'ci:validate' do |t|
  puts 'Validating .circleci/config.yaml ...'
  system("circleci config validate")
end
