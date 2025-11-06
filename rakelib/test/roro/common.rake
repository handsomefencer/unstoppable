require 'rake/testtask'

namespace :test do
  namespace :roro do
      
    desc 'Run roro common tests'
    task :common do 
      Rake::Task['test'].execute
    end
  end
end


