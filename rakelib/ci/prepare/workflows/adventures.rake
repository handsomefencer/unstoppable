namespace :ci do
  namespace :prepare do
    namespace :workflows do

      desc 'Prepare workflow with matrix of adventures'
      task 'adventures' do |task|
        set_content(task)
        reflector = Roro::Configurators::Reflector.new
        cases = reflector.cases
        matrix = @content['jobs'][0]['test-adventures']['matrix']
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
