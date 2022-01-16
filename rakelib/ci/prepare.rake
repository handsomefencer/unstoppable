namespace :ci do
  desc 'Prepare .circlecli/config.yml for deploy'
  task 'prepare' do
    Rake::Task['ci:prepare:workflows:test-matrix-rollon'].execute
    Rake::Task['ci:prepare:workflows:test-matrix-rubies'].execute
    Rake::Task['ci:prepare:config:pack'].invoke
    Rake::Task['ci:prepare:config:process'].invoke
    Rake::Task['ci:prepare:config:validate'].invoke
  end
end