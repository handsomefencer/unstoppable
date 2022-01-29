namespace :docker do
  namespace :image do
    task :build do
      sh 'docker-compose build'
    end
  end
end