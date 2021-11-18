namespace :circleci do
  namespace :matrices do
    namespace :run do
      task 'test_rollons' do |task|
        sh(". ./mise/scripts/debug/matrices/test-rollons.sh")
      end
    end
  end
end
