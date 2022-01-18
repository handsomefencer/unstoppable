namespace :ci do
  namespace :test do
    task :adventures, [:adventure] do |task, args|
      Rake::Task['ci:prepare'].invoke
      if args[:adventure]
        adventures = [args[:adventure]&.split(' ').join(",")]
      else
        adventures = YAML.load_file("#{Dir.pwd}/test/fixtures/matrixes/cases.yml")
      end
      adventures.each do |a|
        job = "test-rollon-#{a.split(',').join("\\n")}-linux"
        sh("circleci local execute -c process.yml --job \"#{job}\"")
      end
    end
  end
end
