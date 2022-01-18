namespace :ci do
  namespace :matrices do
    namespace :run do
      task 'test_rollons' do |task|
        Rake::Task['ci:prepare'].invoke
        sh(". ./mise/scripts/debug/matrices/test-rollons.sh ")
      end
    end
  end
end
