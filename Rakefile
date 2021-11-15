require "bundler/gem_tasks"
require "rake/testtask"
require "json"
require "yaml"
require "roro"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

# workflow = "#{Dir.pwd}/.circleci/src/workflows/test-matrix-rollon.yml"
# hash = read_yaml("#{workflow}")
# hash[:jobs][0][:"test-rollon"][:matrix][:parameters][:answers] = matrix_cases
# File.open(workflow, "w") { |f| f.write(hash.to_yaml) }
desc 'Overwrite .circleci/config.yml section with content in corresponding src'

task :ci, [:section]  do |task, args|
  case_builder = Roro::Configurators::AdventureCaseBuilder.new
  case_builder.build_cases
  cases = case_builder.matrix_cases
  array = args[:section].split('/')
  dest = "#{Dir.pwd}/.circleci/src/#{array.join('/')}.yml"
  source = "#{dest}.tt"
  content = JSON.parse(YAML.load_file(source).to_json)
  content['jobs'][0]['test-rollon']['matrix']['parameters']['answers'] = cases.map { |c| c.join('\n') }
  File.open(dest, "w") { |f| f.write(content.to_yaml) }
  puts 'Wrote answers to file'
  system("circleci config pack .circleci/src/ > .circleci/config.yml")
  puts 'Packed config'
  system("circleci config validate")

end