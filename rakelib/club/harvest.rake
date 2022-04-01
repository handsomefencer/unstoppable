namespace :club do
  desc 'Creates yaml file with likely adventure titles'
  task :harvest do
    sh 'docker-compose build'

  end
end