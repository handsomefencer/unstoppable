# frozen_string_literal: true

require 'test_helper'

describe 'DependencySatisfier' do
  Given(:satisfier)    { DependencySatisfier.new }
  Given(:dependencies) { satisfier.dependencies }
  Given(:manifest)     { [] }

  Given { satisfier.stubs(:manifest).returns(manifest) }

  describe '#gather_base_dependencies' do
    Given(:dependencies) { satisfier.gather_base_dependencies }

    describe 'must return a hash with expected keys' do
      Then { assert_includes dependencies[:git].keys, :command }
      And  { assert_includes dependencies[:git].keys, :help }
      And  { assert_includes dependencies[:git].keys, :name }
    end
  end

  describe '#gather_stack_dependencies' do
    context 'when manifest' do
      Given(:dependencies) { satisfier.gather_stack_dependencies }
      Given(:manifest)     { [stack_path] }

      context 'has no dependencies' do
        Given(:stack) { 'story/valid_env.yml' }
        Then { assert dependencies.empty? }
      end

      context 'has dependencies' do
        Given(:stack) { 'story/story.yml' }
        Then { assert_includes dependencies.keys, :git }
      end

      describe 'is empty must return empty hash' do
        Given(:manifest) { [] }
        Then { assert dependencies.empty? }
      end
    end
  end

  describe '#gather_checks' do
    describe 'must return checks array when manifest' do
      Given(:checks) { satisfier.gather_checks }

      context 'is empty' do
        Given(:manifest) { [] }
        Then { assert_empty checks }
      end

      context 'has a depends_on check' do
        Given(:manifest) { [stack_path] }
        Given(:stack)    { 'story/story.yml' }
        Then { assert_includes checks, 'git' }
      end
    end
  end

  describe '#validate_check(check)' do
    Given(:error_msg) { 'No vaporware dependency exists' }
    Given(:execute)   { satisfier.validate_check('vaporware')}
    Given { satisfier.stubs(:dependencies).returns({}) }
    Then { assert_correct_error }
  end

  describe '#satisfy(check)' do
    Given { skip }
    Given { stubs_dependencies }

    context 'when dependency is met' do
      Given { stubs_host_os(:ubuntu, true)}
      Then  { assert_nil satisfier.satisfy('git') }
    end

    context 'when dependency is not met and hint defined' do
      Given { stubs_host_os(:linux) }
      Then  { assert_equal IO, satisfier.satisfy('git').class }
    end
  end

  describe '#hint(hash, key)' do
    Given(:dependency) { :git }
    Given(:hint_key)   { :help }
    Given(:hint)       { satisfier.hint(dependencies(dependency), hint_key) }
    Given { stubs_dependencies }

    context 'when hint' do
      context 'not configured must return nil' do
        Given(:hint_key) { :not_configured }
        Given { stubs_host_os }
        Then  { assert_nil hint }
      end

      context 'not configured for os must return default' do
        Given { stubs_host_os(:nextOS) }
        Then  { assert_match 'https', hint }
        Then  { assert_match 'https', hint }
      end

      context 'configured for platform' do
        Given(:hint_key) { :lucky }
        Given { stubs_host_os(:fedora) }
        Then { assert_match 'sudo dnf', hint.first }
      end

      context 'configured for alias of platform' do
        Given(:hint_key) { :lucky }
        Given { stubs_host_os(:ubuntu) }
        Then { assert_match 'sudo apt', hint.first }
      end
    end
  end

  describe '#platform_for(dependency_key)' do
    context 'when overrides[:platform]' do
      Given(:platform) { satisfier.platform_for(dependencies(:git)) }
      Given { stubs_dependencies }

      context'includes platform' do
        Given { stubs_host_os(:linux)}
        Then { assert_equal :linux, platform }
      end

      context 'does not include platform' do
        Given { stubs_host_os(:nextOS)}
        Then { assert_empty platform }
      end

      context 'includes aliased platform' do
        Given { stubs_host_os(:ubuntu)}
        Then { assert_equal :debian, platform }
      end
    end
  end

  describe '#platform' do
    Given(:platform) { satisfier.platform }
    Given { stubs_dependencies }

    context 'when linux-based distro' do
      context 'ubuntu' do
        Given { stubs_host_os(:ubuntu)}
        Then  { assert_equal :linux, OS.host_os }
        And   { assert_equal :ubuntu, platform }
      end

      context 'ubuntu' do
        Given { stubs_host_os(:debian) }
        Then  { assert_equal :linux, OS.host_os }
        And   { assert_equal :debian, platform }
      end
    end
  end

  def stubs_host_os(host_os = :linux, met = false)
    case
    when %w[debian redhat ubuntu]
      OS.stubs(:host_os).returns(:linux)
      OS.stubs(:parse_os_release).returns({ ID: "#{host_os.to_sym}" })
    else
      OS.stubs(:host_os).returns(host_os.to_sym)
    end
  end

  def dependencies(key = nil)
    dependencies = read_yaml("#{Roro::CLI.dependency_root}/base.yml")
    key.nil? ? dependencies : dependencies[key]
  end

  def stubs_dependencies
    dependencies = read_yaml("#{Roro::CLI.dependency_root}/base.yml")
    DependencySatisfier.any_instance.stubs(:dependencies).returns(dependencies)
  end
end
