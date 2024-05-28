module Roro::TestHelpers::StackReflectorTestHelper
  def assert_expected_chapters
    assert_equal(
      %w[alpine databases docker git redis] + expected[:chapters],
      adventure[:chapters].map { |f| f.split('/').last.split('.yml').first },
      msg: 'missing chapters'
    )
  end

  def assert_expected_choices
    assert_equal(
      expected[:choices],
      adventure[:choices].map { |f| f.split('/').last.split('.yml').first },
      msg: 'missing choices'
    )
  end

  def assert_expected_env
    breadcrumbs = %i[env base db_vendor value]
    assert_equal(expected.dig(:env).keys, adventure.dig(:env).keys, msg: 'keys')
    assert_equal(expected.dig(*breadcrumbs), adventure.dig(*breadcrumbs), msg: 'keys2')
  end

  def assert_expected_keys
    assert_equal(
      %i[
        chapters choices env itinerary picks pretty_tags tags
        templates_partials_paths templates_paths title versions
      ], adventure.keys.sort, msg: 'missing keys'
    )
  end

  def assert_expected_templates_partials_paths
    actual = adventure[:templates_partials_paths].map! do |f|
      f.split('/')[-3..-1].join('/')
    end
    assert_equal(expected.dig(:templates_partials_paths), actual,
                 msg: 'Missing templates partials path')
  end

  def assert_expected_templates_paths
    actual = adventure[:templates_paths].map! { |f| f.split('/')[-2..-1].join('/') }
    assert_equal(expected.dig(:templates_paths), actual, msg: 'missing templates_paths')
  end

  def generate_adventure_fixture_file
    fixture_file = "#{Roro::CLI.test_root}/fixtures/files/adventure.yml"
    return if File.exist? fixture_file
    subject = Roro::Configurators::StackReflector.new
    picks = '1 1 1'
    adventure = subject.adventure_for(*picks)
    File.open(file, 'w') { |f| f.write(adventure.to_yaml) }
  end

  def adventure_fixture
    generate_adventure_fixture_file
    file = "#{Roro::CLI.test_root}/fixtures/files/adventure.yml"
    yaml = read_yaml(file)
  end

  def assert_expected_adventure

    %i[
      itinerary
      picks
      tags
      title
      versions
    ].each do |key|
      assert_equal(expected[key], adventure[key], msg: "missing #{key}") if expected[key]
    end
    assert_expected_chapters
    assert_expected_choices
    assert_expected_env
    assert_expected_keys
    assert_expected_templates_partials_paths
    assert_expected_templates_paths
  end
end
