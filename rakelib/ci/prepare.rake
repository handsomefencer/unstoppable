namespace :ci do
  desc 'prepare workflows and config'
  task 'prepare' do
    Rake::Task['ci:prepare:workflows'].execute
    Rake::Task['ci:prepare:config'].execute
  end
end
