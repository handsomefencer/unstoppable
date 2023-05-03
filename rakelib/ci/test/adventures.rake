namespace :ci do
  namespace :test do
    task :adventures, [:adventure] do |_task, args|
      Rake::Task['ci:prepare'].invoke
      adventure = (args[:adventure] || '0 -1').split(' ')
      adventures = YAML.load_file("#{Dir.pwd}/test/fixtures/matrixes/cases.yml")
      adventures[adventure.first.to_i..adventure.last.to_i].each do |a|
        job = "test-rollon-#{a.join('\\n')}-linux"
        sh("circleci local execute -c process.yml --job \"#{job}\"")
      end
    end

    task :run, [:job] do |_task, args|
      Rake::Task['ci:prepare'].invoke
      sh("circleci local execute -c process.yml --job \"#{args[:job]}\"")
    end
  end
end
