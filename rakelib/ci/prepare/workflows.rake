namespace :ci do
  namespace :prepare do
    desc 'Prepare workflows'
    task 'workflows' do
      Rake::Task['ci:prepare:workflows:test-matrix-rollon'].execute
    end

    namespace :workflows do
      desc 'Prepare workflow test-matrix-rollon'
      task 'test-matrix-rollon' do |task|
        set_content(task)
        cases = YAML.load_file("test/fixtures/matrixes/cases.yml")
        matrix = @content['jobs'][0]['test-rollon']['matrix']
        matrix['parameters']['answers'] = cases.map { |c| c.join('\n') }
        overwrite
        notify('answers')
      end

      private

      def set_content(task)
        wf = "#{Dir.pwd}/.circleci/src/workflows/#{task.name.split(':').last}"
        @dest = "#{wf}.yml"
        @content = JSON.parse(YAML.load_file("#{wf}.yml.tt").to_json)
      end

      def overwrite
        File.open(@dest, "w") { |f| f.write(@content.to_yaml) }
      end

      def notify(string)
        puts "Wrote #{string} to #{@dest}"
      end
    end
  end
end
