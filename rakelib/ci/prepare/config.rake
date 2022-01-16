namespace :ci do
  namespace :prepare do
    desc 'prepare config'
    task 'config' do
      Rake::Task['config:pack'].execute
      # Rake::Task['ci:prepare:config:process'].execute
    end
  end
end
