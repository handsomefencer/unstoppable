namespace :ci do
  desc 'Prepare .circlecli/config.yml for deploy'
  task 'prepare' do
    Rake::Task['ci:process:workflows'].invoke
    Rake::Task['ci:config:pack'].invoke
    Rake::Task['ci:config:validate'].invoke
  end
end