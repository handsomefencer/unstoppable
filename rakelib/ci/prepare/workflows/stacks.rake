namespace :ci do
  namespace :prepare do
    namespace :workflows do

      task 'stacks' do |task|
        set_content(task)
        matrix = @content['jobs'][1]['test-stacks']['matrix']
        matrix['parameters']['database'] = %w[postgres mysql]
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
