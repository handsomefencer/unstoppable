module Minitest
  class Spec
    def assert_expected_chapters
      assert_equal(
        %w[alpine databases docker git redis] + expected[:chapters],
        adventure[:chapters].map { |f| f.split('/').last.split('.yml').first },
        msg: 'missing chapters'
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
          chapters env itinerary picks tags templates_partials_paths
          templates_paths title versions
        ], adventure.keys.sort, msg: 'missing keys'
      )
    end

    def assert_expected_templates_partials_paths
      actual = adventure[:templates_partials_paths].map! do |f|
        f.split('/')[-3..-1].join('/')
      end
      assert_equal(expected.dig(:templates_partials_paths), actual, msg: 'blah')
    end

    def assert_expected_templates_paths
      actual = adventure[:templates_paths].map! { |f| f.split('/')[-2..-1].join('/') }
      assert_equal(expected.dig(:templates_paths), actual, msg: 'missing templates_paths')
    end

    def assert_expected_adventure
      %i[itinerary picks tags title versions].each do |key|
        assert_equal(expected[key], adventure[key], msg: "missing #{key}") if expected[key]
      end
      assert_expected_chapters
      assert_expected_env
      assert_expected_keys
      assert_expected_templates_partials_paths
      assert_expected_templates_paths
    end
  end
end
