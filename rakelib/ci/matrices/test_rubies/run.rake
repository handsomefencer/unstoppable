namespace :ci do
  namespace :matrices do
    namespace :test_rubies do
      desc 'Run local'
      task 'run' do |task|
        sh('circleci config process .circleci/config.yml > process.yml && circleci local execute -c process.yml --job test-3.0')

        # rubies = %w[2.5]
        # rubies.each do |ruby|
        #   `circleci config process .circleci/config.yml > process.yml`
        #   `circleci local execute -c process.yml --job test-3.0`
        # end
      end
    end
  end
end
