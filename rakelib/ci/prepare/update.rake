namespace :ci do
  desc 'prepare config'
  task 'update' do
    system("sudo circleci update")
  end
end
