namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Prepare workflow with matrix of adventures'
      task 'test-adventures' do |task|
        set_content(task)
        cases = YAML.load_file("test/fixtures/matrixes/cases.yml")
        matrix = @content['jobs'][0]['test-rollon']['matrix']
        matrix['parameters']['answers'] = cases.map { |c| c.join('\n') }
        overwrite
        notify('answers')
      end
    end

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
