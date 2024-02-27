namespace :ci do
  namespace :prepare do
    namespace :workflows do

      desc 'Prepare workflow test-rubies'
      task 'rubies' do |task|
        set_content(task)
        matrix = @content['jobs'][0]['test-rubies']['matrix']
        matrix['parameters']['version'] = %w[3.1 3.2 3.3]
        matrix['parameters']['folder'] = %w[cli common configurators crypto]
        overwrite
        notify 'version'
      end
    end

    def set_content(task)
      wf = "#{Dir.pwd}/.circleci/src/workflows/#{task.name.split(':').last}"
      @dest = "#{wf}.yml"
      @content = JSON.parse(YAML.load_file("#{wf}.yml.tt").to_json)
    end

    def overwrite
      File.open(@dest, 'w') { |f| f.write(@content.to_yaml) }
    end

    def notify(string)
      puts "Wrote #{string} to #{@dest}"
    end

    def ci_cases
      Roro::Configurators::StackReflector.new.cases
    end

  end
end
