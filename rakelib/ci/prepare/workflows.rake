namespace :ci do
  namespace :prepare do

    desc 'prepare workflows in for .circleci/config.yml'
    task 'workflows' do
      matchers = [
        'rails_8_1 tailwind sqlite bun ruby_3_3'
        # 'skip_css importmaps omakase rails_8_1 ruby_3_3',
      #   'tailwind postgres importmaps okonomi'
      ].join(' ; ')

      args = Rake::TaskArguments.new([:matchers], [matchers])

      Rake::Task['ci:prepare:workflows:rubies'].execute
      Rake::Task['ci:prepare:workflows:test'].execute(args)
    end
  end
end
