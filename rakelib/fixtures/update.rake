namespace :test do
  namespace :fixtures do
    task 'update' do |task|
      Rake::Task['circleci:prepare'].invoke
      sh(". ./mise/scripts/debug/matrices/test-rollons.sh ")
    end
  end
end
