require 'debug'

namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Create split test files'

      task :test, [:matchers]  do |task, args|
        if args.matchers.nil?
          stacks = Dir.glob("test/roro/stacks/**/*_test.rb")
        else
          stacks = []
          args.matchers.split(';').each do |array|
            candidates = Dir.glob("test/roro/stacks/**/*_test.rb")
            array.split.each { |m| candidates.select! { |c| c.match?(m) } }
            stacks += candidates
          end
        end
        fixtures = Dir.glob("test/fixtures/**/*_test.rb")
        roro = Dir.glob("test/**/*_test.rb") - fixtures - stacks
        FileUtils.mkdir_p("#{Dir.pwd}/.circleci/splits")
        { roro: roro, stacks: stacks }.each do |k,v|
          File.open(".circleci/splits/testfiles_#{k.to_s}.txt", 'w') { |f| f.write(v.join("\n")) }
        end
      end
    end
  end
end
