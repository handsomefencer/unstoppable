
namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Creat split test files'

      task 'test' do |task|
        fixtures = Dir.glob("test/fixtures/**/*_test.rb")
        stacks = Dir.glob("test/roro/stacks/**/*_test.rb")
        roro = Dir.glob("test/**/*_test.rb") - fixtures - stacks
        FileUtils.mkdir_p("#{Dir.pwd}/.circleci/splits")
        %w[roro stacks].each do |item|
          File.open(".circleci/splits/testfiles_#{item.to_s}.txt", 'w') { |f| f.write(eval(item)) }
        end
      end
    end
  end
end
