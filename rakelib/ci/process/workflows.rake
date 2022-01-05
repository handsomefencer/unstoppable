namespace :ci do
  namespace :process do
    desc 'Process workflows'
    task 'workflows' do
      namespace 'ci:process:workflows' do
        Rake::Task['test-matrix-rollon'].invoke
      end
    end

    namespace :workflows do
      task 'test-matrix-rollon' do |task|
        set_content(task)
        case_builder = Roro::Configurators::AdventureCaseBuilder.new
        case_builder.build_cases_matrix
        value = case_builder.matrix.map { |c| c.join('\n') }
        matrix = @content['jobs'][0]['test-rollon']['matrix']
        matrix['parameters']['answers'] = value
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
