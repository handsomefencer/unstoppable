require 'rake/testtask'

namespace :test do
  namespace :roro do
      
    desc 'Run roro cli tests'
    task :cli do 
      Rake::Task['test'].execute
    end
  end
end


