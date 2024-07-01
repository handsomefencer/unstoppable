
namespace :ci do
  namespace :prepare do
    namespace :workflows do
      desc 'Creat split test files'

      task 'test' do |task|
        base = "#{Dir.pwd}/test"
        fixtures = Dir.glob("#{base}/fixtures/**/*_test.rb")
        stacks = Dir.glob("#{base}/roro/stacks/**/*_test.rb")
        roro = Dir.glob("#{base}/**/*_test.rb") - fixtures - stacks
        FileUtils.mkdir_p("#{Dir.pwd}/.circleci/splits")
        %w[roro stacks].each do |item|
          File.open(".circleci/splits/testfiles_#{item.to_s}.txt", 'w') { |f| f.write(eval(item)) }
        end
      end
    end
  end
end
