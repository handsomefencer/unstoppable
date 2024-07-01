namespace :ci do
  desc 'Update circleci CLI tool'
  task 'update' do
    system("sudo -S circleci update")
  end
end
