
class Roro::CLI < Thor

  include Thor::Actions

  def self.source_root
    "#{File.dirname(__FILE__)}/templates"
  end

  def self.story_root
    "#{File.dirname(__FILE__)}/stories"
  end

  def self.test_fixture_root
    "#{File.dirname(__FILE__)}/test/fixtures"
  end

  def self.roro_environments
    %w[development production test staging ci]
  end
end
