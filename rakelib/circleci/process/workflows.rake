namespace :ci do
  namespace :process do
    desc 'Process workflows'
    task 'workflows' do
      namespace 'ci:process:workflows' do
        Rake::Task['test-matrix-rollon'].invoke
      end
    end

    namespace :workflows do
      task 'test-matrix-rollon' do |t|
        case_builder = Roro::Configurators::AdventureCaseBuilder.new
        case_builder.build_cases
        cases = case_builder.matrix_cases
        array =  'workflows/test-matrix-rollon'.split('/')
        dest = "#{Dir.pwd}/.circleci/src/#{array.join('/')}.yml"
        source = "#{dest}.tt"
        content = JSON.parse(YAML.load_file(source).to_json)
        content['jobs'][0]['test-rollon']['matrix']['parameters']['answers'] = cases.map { |c| c.join('\n') }
        File.open(dest, "w") { |f| f.write(content.to_yaml) }
        puts 'Wrote answers to file'
      end

      private
      def getsome
        case_builder = Roro::Configurators::AdventureCaseBuilder.new
        case_builder.build_cases
        cases = case_builder.matrix_cases
        array =  'workflows/test-matrix-rollon'.split('/')
        dest = "#{Dir.pwd}/.circleci/src/#{array.join('/')}.yml"
        source = "#{dest}.tt"
        content = JSON.parse(YAML.load_file(source).to_json)
        content['jobs'][0]['test-rollon']['matrix']['parameters']['answers'] = cases.map { |c| c.join('\n') }
        File.open(dest, "w") { |f| f.write(content.to_yaml) }
        puts 'Wrote answers to file'
      end

    end
  end
end
