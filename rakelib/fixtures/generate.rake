namespace :fixtures do

  desc 'Generate fixtures'
  task :generate do |task|
    Rake::Task['fixtures:generate:cases'].execute
    Rake::Task['fixtures:generate:itineraries'].execute
  end

  namespace :generate do
    desc 'Generate itineraries'
    task :itineraries do |task|
      create_fixture_matrix('cases') do
        Rake::TestTask.new(task) do |t|
          t.libs << "test"
          t.test_files = FileList['test/fixtures/generate_test.rb']
          t.verbose = true
        end
      end
    end

    desc 'Generate cases'
    task :cases do |task|
      create_fixture_matrix('cases') do
        File.open("#{Dir.pwd}/#{@path}", "w+") do |f|
          builder = Roro::Configurators::AdventureCaseBuilder.new
          f.write(builder.build_cases_matrix.to_yaml)
        end
      end
    end

    private

    def create_fixture_matrix(fixture, &block)
      @path = "test/fixtures/matrixes/#{fixture}.yml"
      puts "Creating #{@path} ..."
      block.call
      puts "Created #{@path}"
    end
  end
end
