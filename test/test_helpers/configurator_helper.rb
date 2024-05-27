# frozen_string_literal: true

module Roro::TestHelpers::ConfiguratorHelper


  def use_fixture_stack(stack = nil)
    return unless stack

    fixture_stacks = 'fixtures/files/stacks'
    Roro::CLI
      .stubs(:stacks)
      .returns("#{Roro::CLI.test_root}/#{fixture_stacks}/#{stack}")
  end

  def fixture_file_content(filename)
    File.read("#{@roro_dir}/test/fixtures/files/#{filename}")
  end

  def debuggerer
    @rollon_dummies = true
    @rollon_loud = true
  end

  def assert_correct_manifest(story)
    debuger
    debuggerer if ENV['DEBUGGERER'].eql?('true')

    story = StoryRehearser.new(dir)
    story.rollon
    hash = story.merge_manifests
    story.choices.each do |fm|
      hash.dig(fm.to_sym)&.each do |filename, matchers|
        if matchers.nil?
          assert_file filename.to_s
        else
          matchers.each do |matcher|
            msg = "#{filename} in #{dir}/dummy/#{filename} does not contain #{matcher}"
            if matcher.is_a?(Hash)
              assert_yaml(filename.to_s, matcher)
            elsif matcher.chars.first.match?('/')
              regex = matcher.chars
              regex.shift
              regex.pop
              regex.join
              begin
                assert_file(filename.to_s, eval("#{matcher}"))
              rescue
                debugger
              end
            else
              assert_file(filename.to_s, eval(matcher))
            end
          end
        end
      end
    end
  end

    #   def insert_dummy_files(*files)
    #   expected_files ||= []
    #   @dummyfiles ||= expected_files
    #   @dummyfiles += files
    # end

# def copy_stage_dummy(path)
  #   dummy_dir = "#{path}/dummy/."
  #   FileUtils.cp_r(dummy_dir, Dir.pwd) if File.exist?(dummy_dir)
  # end

  # def capture_stage_dummy(dir)
  #   dummy_dir = "#{dir}/dummy"
  #   FileUtils.remove_dir(dummy_dir) if File.exist?(dummy_dir)
  #   FileUtils.mkdir_p(dummy_dir)
  #   @dummyfiles.each do |df|
  #     next unless File.directory?(df)

  #     @dummyfiles += glob_dir(df).map do |mig|
  #       mig = mig.split("#{Dir.pwd}/").last
  #     end
  #     @dummyfiles.delete(df)
  #   end
  #   @dummyfiles.each do |dummy|
  #     dummyfile = dummy.split(dummy_dir).last
  #     artifact = "#{Dir.pwd}/#{dummyfile}"
  #     next unless File.file?("#{Dir.pwd}/#{dummyfile}") && File.file?(dummyfile)

  #     array = dummyfile.split('/')
  #     array.pop
  #     target = array.join('/')
  #     FileUtils.mkdir_p("#{dummy_dir}/#{target}")
  #     FileUtils.cp_r(artifact, "#{dummy_dir}/#{dummy}")
  #   end
  # end



  # def set_manifest_for_rollon(dir, array = [])
  #   @filematchers ||= []
  #   array = dir.split('/')
  #   name = array.pop
  #   @filematchers << name
  #   stack_test_root = "#{Roro::CLI.test_root}/roro/stacks"
  #   manifest = "#{stack_test_root}/_manifest.yml"
  #   files = read_yaml(manifest)[name.to_sym]&.keys&.map(&:to_s)
  #   # foo = read_yaml(manifest)[:stacks]
  #   # debugger
  #   insert_dummy_files(*files)
  #   return if dir.eql?(stack_test_root)

  #   set_manifest_for_rollon(array.join('/'))
  # end

  # def rollon(dir)
  #   set_manifest_for_rollon(dir)
  #   debuggerer if ENV['DEBUGGERER'].eql?('true')
  #   # workbench
  #   stubs_adventure(dir)
  #   stubs_dependencies_met?
  #   stubs_yes?
  #   stub_overrides
  #   if @rollon_dummies.eql?(true)
  #     # ENV['RORO_DOCUMENT_LAYERS'] = 'true'
  #     cli = Roro::CLI.new
  #     # system 'docker-compose down' if @rollon_dummies.eql?(true)
  #     @rollon_loud ? cli.rollon : quiet { cli.rollon }
  #     capture_stage_dummy(dir) if @rollon_dummies.eql?(true)
  #     # system 'docker-compose down' if @rollon_dummies.eql?(true)
  #   else
  #     copy_stage_dummy(dir)
  #     stub_run_actions
  #   end
  # end

  # def verify_manifest(dir = nil, file = nil)
  #   hash ||= read_yaml("#{Roro::CLI.test_root}/roro/stacks/#{file}")
  #   @filematchers.reverse.each do |fm|
  #     hash.dig(fm.to_sym)&.each do |filename, matchers|
  #       if matchers.nil?
  #         assert_file filename.to_s
  #       else
  #         matchers.each do |matcher|
  #           msg = "#{filename} in #{dir}/dummy/#{filename} does not contain #{matcher}"
  #           if matcher.is_a?(Hash)
  #             assert_yaml(filename.to_s, matcher)
  #           elsif matcher.chars.first.match?('/')
  #             regex = matcher.chars
  #             regex.shift
  #             regex.pop
  #             regex.join
  #             assert_file(filename.to_s, eval("#{matcher}"))
  #           else
  #             assert_file(filename.to_s, eval(matcher))
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  # def assert_correct_manifest(dir = nil, hash = nil)
  #   manifests = Dir.glob("#{Roro::CLI.test_root}/roro/stacks/_*.yml")
  #   manifests.each do |manifest|
  #     verify_manifest(dir, manifest.split('/').last)
  #   end
  # end


  # def stubs_adventure(path = nil, _adventure = nil)
  #   answers = infer_answers_from_testfile_location
  #   Roro::Configurators::AdventurePicker
  #     .any_instance
  #     .stubs(:ask)
  #     .returns(*answers)
  # end

  # def infer_answers_from_testfile_location(path = nil)
  #   test_stack_root = "#{Roro::CLI.test_root}/roro/stacks"
  #   array = path.split("#{test_stack_root}/").last.split('/')
  #   reflector = Roro::Configurator::StackReflector.new
  #   begin
  #     foo = reflector.adventures
  #     .select { |_k, v| v[:choices].map(&:downcase).eql?(array) }
  #     .values.first[:picks]
  #   rescue
  #   end
  # end

  def stub_journey(answers)
    Thor::Shell::Basic
      .any_instance
      .stubs(:ask)
      .returns(*answers)
  end

  def stubs_yes?(answer = 'yes')
    Thor::Shell::Basic.any_instance
                      .stubs(:yes?)
                      .returns(answer)
  end


  def stack_path(args = nil)
    append = defined?(stack) ? "/#{stack}" : nil
    prepend_valid = args.eql?(:invalid) ? 'invalid' : 'valid'
    stack_root ||= "#{Roro::CLI.test_root}/fixtures/dummies/stack/#{prepend_valid}"
    "#{stack_root}#{append}"
  end

  def assert_valid_stack
    assert_nil validator.validate(stack_path)
  end
  # def copy_stage_dummy(path)
  #   dummy_dir = "#{path}/dummy/."
  #   FileUtils.cp_r(dummy_dir, Dir.pwd) if File.exist?(dummy_dir)
  # end

  def quiet
    original_stderr = $stderr.clone
    original_stdout = $stdout.clone
    $stderr.reopen(File.new('/dev/null', 'w'))
    $stdout.reopen(File.new('/dev/null', 'w'))
    yield
  ensure
    $stdout.reopen(original_stdout)
    $stderr.reopen(original_stderr)
  end

  def expected_adventure_cases
    [
      '1 1 1',           '1 1 2',           '1 2 1 1 1',
      '1 2 1 1 2',       '1 2 1 2 1',       '1 2 1 2 2',
      '1 2 2 1',         '1 2 2 2',         '1 3 1 1 1 1 1 1',
      '1 3 1 1 1 1 1 2', '1 3 1 1 1 1 2 1', '1 3 1 1 1 1 2 2',
      '1 3 1 1 1 2 1 1', '1 3 1 1 1 2 1 2', '1 3 1 1 1 2 2 1',
      '1 3 1 1 1 2 2 2', '1 3 1 1 2 1 1 1', '1 3 1 1 2 1 1 2',
      '1 3 1 1 2 1 2 1', '1 3 1 1 2 1 2 2', '1 3 1 1 2 2 1 1',
      '1 3 1 1 2 2 1 2', '1 3 1 1 2 2 2 1', '1 3 1 1 2 2 2 2',
      '1 3 1 2 1 1 1',   '1 3 1 2 1 1 2',   '1 3 1 2 1 2 1',
      '1 3 1 2 1 2 2',   '1 3 1 2 2 1 1',   '1 3 1 2 2 1 2',
      '1 3 1 2 2 2 1',   '1 3 1 2 2 2 2',   '1 3 2 1',
      '1 3 2 2',         '2 1',             '2 2',
      '3 1',             '3 2'
    ]
  end
end
