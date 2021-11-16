desc 'Process .circleci/src'
task 'ci:process', [:workflows] do |t|
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
