namespace :circleci do
  desc 'Prepare .circlecli/config.yml for deploy'
  task 'prepare' do |task|
    Rake::Task['ci:process:workflows'].invoke
  end
end