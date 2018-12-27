require "test_helper"

describe Roro::CLI do


  Given(:subject) { Roro::CLI.new }
  Given { prepare_destination }

  describe ":greenfield" do

    describe "without arguments" do

      Given { subject.greenfield }

      # dockerized_app

    end
  end
end
