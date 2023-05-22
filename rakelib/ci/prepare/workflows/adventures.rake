require 'byebug'

namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Prepare workflow with matrix of adventures'
      task 'adventures' do |task|
        # cases = Roro::Configurators::Reflector.new.cases
        set_content(task)
        matrix = @content['jobs'][0]['test-adventures']['matrix']
        matrix['parameters']['answers'] = ci_cases
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
      File.open(@dest, 'w') { |f| f.write(@content.to_yaml) }
    end

    def notify(string)
      puts "Wrote #{string} to #{@dest}"
    end

    def ci_cases
      [
        '1 1 1',
        '1 1 1',
        '1 1 2',
        '1 2 1 1 1',
        '1 2 1 1 2',
        '1 2 1 2 1',
        '1 2 1 2 2',
        '1 2 2 1',
        '1 2 2 2',
        '1 3 1 1 1 1 1 1',
        '1 3 1 1 1 1 1 2',
        '1 3 1 1 1 1 2 1',
        '1 3 1 1 1 1 2 2',
        '1 3 1 1 1 2 1 1',
        '1 3 1 1 1 2 1 2',
        '1 3 1 1 1 2 2 1',
        '1 3 1 1 1 2 2 2',
        '1 3 1 1 2 1 1 1',
        '1 3 1 1 2 1 1 2',
        '1 3 1 2 1 1 1',
        '1 3 1 2 1 1 2',
        '1 3 1 2 1 2 1',
        '1 3 1 2 1 2 2',
        '1 3 2 1',
        '1 3 2 2',
        '2 1',
        '2 2',
        '3 1',
        '3 2'
      ].map { |item| item.split(' ').join('\n') }
    end

    def ci_cases
      cases = Roro::Configurators::Reflector.new.cases
      cases.map { |c| c.join('\\n') }
    end
  end
end
