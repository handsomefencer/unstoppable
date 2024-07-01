namespace :ci do
  desc 'prepare config'
  task 'update' do
    system("sudo -S circleci update")
  end
end
