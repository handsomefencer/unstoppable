namespace :ci do
  desc 'Overwrite .circleci/config.yml section with content in corresponding src'
  task :prepare => [:ci, :pack, :validate]




  desc 'Adds answers from AdventureCaseBuilder to matrix'
  task :ci, [:section]  do |task, args|
    case_builder = Roro::Configurators::AdventureCaseBuilder.new
    case_builder.build_cases
    cases = case_builder.matrix_cases
    array = (args[:section] || 'workflows/test-matrix-rollon').split('/')
    dest = "#{Dir.pwd}/.circleci/src/#{array.join('/')}.yml"
    source = "#{dest}.tt"
    content = JSON.parse(YAML.load_file(source).to_json)
    content['jobs'][0]['test-rollon']['matrix']['parameters']['answers'] = cases.map { |c| c.join('\n') }
    File.open(dest, "w") { |f| f.write(content.to_yaml) }
    puts 'Wrote answers to file'

  end
end