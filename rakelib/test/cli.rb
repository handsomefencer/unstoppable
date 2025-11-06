
namespace :test do
  namespace :roro do
      
      desc 'run roro cli tests'
      task 'cli' do |t|
        puts   'Packing .circleci/config.yaml ...'
        # system 'circleci config pack .circleci/src/ > .circleci/config.yml'
        # puts   'Packed .circleci/config.yml'
    end
  end
end


