namespace :ci do
  namespace :prepare do
    desc 'prepare config'
    task 'config' do
      Rake::Task['ci:prepare:config:pack'].invoke
      Rake::Task['ci:prepare:config:process'].invoke
      Rake::Task['ci:prepare:config:validate'].invoke
    end
  end
end
