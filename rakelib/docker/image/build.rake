namespace :docker do
  namespace :image do
    desc 'getsome'
    task :build do
      sh 'docker-compose build'
    end
  end
end