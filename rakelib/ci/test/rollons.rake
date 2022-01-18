namespace :ci do
  namespace :test do
    task 'rollons' do |task|
      Rake::Task['ci:prepare'].invoke
      # sh(". ./mise/scripts/debug/matrices/test-rollons.sh ")
      sh('circleci local execute -c process.yml --job "test-rollon-2\n5-linux"')

    end
  end
end
