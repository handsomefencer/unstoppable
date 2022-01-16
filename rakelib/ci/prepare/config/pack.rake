
namespace :ci do
  namespace :prepare do
    namespace :config do
      desc 'Pack .circleci/config.yml from .circleci/src files'
      task 'pack' do |t|
        puts 'Packing .circleci/config.yaml ...'
        system("circleci config pack .circleci/src/ > .circleci/config.yml")
        puts 'Packed .circleci/config.yml'
      end
    end
  end
end


