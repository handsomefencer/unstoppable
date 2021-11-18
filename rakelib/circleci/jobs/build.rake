namespace :circleci do
  namespace :jobs do
    task 'build' do |task|
      sh(". ./mise/scripts/debug/jobs/build.sh ")
    end
  end
end
