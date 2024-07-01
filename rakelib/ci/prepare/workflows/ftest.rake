require 'debug'

namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Prepare workflow test'

      task 'test' do |task|
        debugger
        FileUtils.mkdir_p("#{Dir.pwd}/test/ci")
        # def set_content(task)
#       wf = "#{Dir.pwd}/.circleci/src/workflows/#{task.name.split(':').last}"
#       @dest = "#{wf}.yml"
#       @content = JSON.parse(YAML.load_file("#{wf}.yml.tt").to_json)
#     end
        # testfiles = Dir.glob("#{Dir.pwd}/test/roro/stacks/**/*_test.rb")

        # puts 'barf'
        # File.open("#{Dir.pwd}/test/ci/splits.txt", 'w') { |f| f.write(testfiles) }

#         set_content(task)
#         matrix = @content['jobs'][1]['test-stacks']['matrix']
#         matrix['parameters']['database'] = %w[postgres]
#         overwrite
#         notify 'version'
      end
    end

#     def set_content(task)
#       wf = "#{Dir.pwd}/.circleci/src/workflows/#{task.name.split(':').last}"
#       @dest = "#{wf}.yml"
#       @content = JSON.parse(YAML.load_file("#{wf}.yml.tt").to_json)
#     end

#     def overwrite
#       File.open(@dest, 'w') { |f| f.write(@content.to_yaml) }
#     end

#     def notify(string)
#       puts "Wrote #{string} to #{@dest}"
#     end

#     def ci_cases
#       Roro::Configurators::StackReflector.new.cases
#     end

  end
end
