namespace :test do
  
  desc 'Run roro tests'
  task :tasks do
    Rake::Task['test'].execute
  end
end
