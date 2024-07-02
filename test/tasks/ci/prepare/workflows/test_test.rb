# frozen_string_literal: true

require 'rake_test_helper'

describe 'rake ci:prepare:workflows:test' do
  Given(:workbench) { 'active/test' }
  Given(:execute) { run_task('ci:prepare:workflows:test') }
  Given(:splits) { ".circleci/splits/testfiles"}
  Given(:stacks) { ".circleci/splits/testfiles_stacks.txt"}
  Given(:roro) { ".circleci/splits/testfiles_roro.txt"}
  Then do
    execute
    assert_equal 3, globdir('test/roro/stacks/**/*_test.rb').size
    assert_equal 1, globdir(stacks).size
    assert_equal 1, globdir(roro).size
    assert_content stacks, /sqlite\/importmaps\/omakase/
    # assert_content roro, /cli\/generate\/generate_exposed_test/
    # refute_content stacks, /test\/fixtures/
    # refute_content stacks, /cli\/generate\/generate_exposed_test/
    # refute_content roro,  /sqlite\/importmaps\/omakase/
    # refute_content roro, /test\/fixtures/
  end
end
