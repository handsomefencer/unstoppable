namespace :ci do
  namespace :prepare do

    desc 'prepare workflows in for .circleci/config.yml'
    task 'workflows' do
      matchers = [
        'tailwind sqlite okonomi',
        'tailwind postgres importmaps okonomi'
      ].join(' ; ')

      args = Rake::TaskArguments.new([:matchers], [matchers])

      Rake::Task['ci:prepare:workflows:rubies'].execute
      Rake::Task['ci:prepare:workflows:test'].execute(args)
    end
  end
end
