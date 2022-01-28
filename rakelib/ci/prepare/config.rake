namespace :ci do
  namespace :prepare do
    desc 'prepare config'
    task 'config' do
      Rake::Task['config:pack'].execute
    end
  end
end
