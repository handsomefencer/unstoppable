require "test_helper"

describe Roro::CLI do

  Given(:subject) { Roro::CLI.new }
 
    # Given { prepare_destination rails_version }
  describe "must create" do
Given { skip }
    Given { subject.rollon }

    Then {
      assert_file 'Gemfile', /gem \'pg\'/
      assert_file 'Gemfile', /gem \'sshkit\'/
      assert_file 'Guardfile'

      assert_file 'roro'
    }
  end
end
