namespace :ci do
  namespace :test do
    desc 'Run tests in different rubies'
    task 'rubies', [:rubies] do |task, args|
      Rake::Task['ci:prepare'].invoke
      rubies = args[:rubies]&.split(' ') || Roro::CLI.supported_rubies
      rubies.each do |r|
        sh("circleci local execute -c process.yml --job test-rubies-#{r}")
      end
    end
  end
end
