require 'rake/testtask'

namespace :test do
  namespace :roro do
      
    desc 'Run roro stacks tests'
    task :stacks do 
      ENV['DEBUGGERER'] = 'true'
      Rake::Task['test'].execute
    end
  end
end


