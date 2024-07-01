
namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Prepare workflow test'

      task 'test' do |task|
        fixtures = Dir.glob("#{Dir.pwd}/test/fixtures/**/*_test.rb")
        stacks = Dir.glob("#{Dir.pwd}/test/roro/stacks/**/*_test.rb")
        roro = Dir.glob("#{Dir.pwd}/test/**/*_test.rb") - fixtures - stacks
        FileUtils.mkdir_p("#{Dir.pwd}/.circleci/splits")
        File.open('.circleci/splits/testfiles_roro.txt', 'w') { |f|
          f.write(roro) }
        File.open('.circleci/splits/testfiles_stacks.txt', 'w') { |f|
          f.write(stacks) }
      end
    end
  end
end
