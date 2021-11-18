namespace :circleci do
  desc 'Prepare .circlecli/config.yml for deploy'
  task 'prepare' do
    Rake::Task['circleci:process:workflows'].invoke
    Rake::Task['circleci:config:pack'].invoke
    Rake::Task['circleci:config:validate'].invoke
  end
end