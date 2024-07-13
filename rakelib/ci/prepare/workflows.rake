namespace :ci do
  namespace :prepare do

    desc 'prepare workflows in for .circleci/config.yml'
    task 'workflows' do
      matchers = [
      #   'skip_css importmaps omakase',
      #   'tailwind postgres importmaps okonomi'
      ].join(' ; ')

      args = Rake::TaskArguments.new([:matchers], [matchers])

      Rake::Task['ci:prepare:workflows:rubies'].execute
      Rake::Task['ci:prepare:workflows:test'].execute(args)
    end
  end
end
