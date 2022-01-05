namespace :release do
  namespace :matrices do
    namespace :run do
      task 'test_rollons' do |task|
        Rake::Task['circleci:prepare'].invoke
        sh(". ./mise/scripts/debug/matrices/test-rollons.sh ")
      end
    end
  end
end
