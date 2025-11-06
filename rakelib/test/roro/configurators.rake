require 'rake/testtask'

namespace :test do
  namespace :roro do
      
    desc 'Run roro configurators tests'
    task :configurators do 
      Rake::Task['test'].execute
    end
  end
end


