require 'rake/testtask'

namespace :test do
  namespace :roro do
      
    desc 'Run roro crypto tests'
    task :crypto do 
      Rake::Task['test'].execute
    end
  end
end


