namespace :ci do
  namespace :prepare do

    desc 'prepare workflows in for .circleci/config.yml'
    task 'workflows' do
      Rake::Task['ci:prepare:workflows:rubies'].execute
      Rake::Task['ci:prepare:workflows:test'].execute
    end
  end
end
