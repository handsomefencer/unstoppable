require 'debug'

namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Create split test files'

      task :test do |task, args|
        if args&.extras
          stacks = []
          args.extras.first.split(';').each do |array|
            candidates = Dir.glob("test/roro/stacks/**/*_test.rb")
            array.split.each { |m| candidates.select! { |c| c.match?(m) } }
            stacks += candidates
          end
        else
          stacks = Dir.glob("test/roro/stacks/**/*_test.rb")
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
