namespace :club do
  desc 'Creates yaml file with likely adventure titles'
  task :harvest do
    stack = Roro::CLI.stacks
    target = '.harvest.yml'
    File.open(target, 'w') { |f| f.write('blah') }
    # harvest = File.open(target, "w") { |f| f.write(content.to_yaml) }
  end
end
