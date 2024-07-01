namespace :ci do
  desc 'prepare workflows and config'
  task 'prepare' do
    Rake::Task['ci:update'].execute
    Rake::Task['ci:prepare:workflows'].execute
    Rake::Task['ci:prepare:config:pack'].invoke
    Rake::Task['ci:prepare:config:process'].invoke
    Rake::Task['ci:prepare:config:validate'].invoke
  end
end
