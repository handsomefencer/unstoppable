module TestHelper
  module Files
    module Assertions

      def prepare_destination(test_app=nil)
        Dir.chdir(ENV.fetch("PWD") + '/tmp')
        unless test_app.nil?
          temp_name = test_app.split('/').last
          FileUtils.rm_rf(test_app.split('/').last)
          FileUtils.cp_r("../test/dummies/#{test_app}", ".")
          Dir.chdir(temp_name)
        end
      end
    end
  end
end
