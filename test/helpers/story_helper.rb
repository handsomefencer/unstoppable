module Roro::Test::Helpers::Stories::WorkBench
  def assert_roro_generated
    assert_directory './roro'
    assert_directory './roro/keys'
    assert_directory './roro/scripts'
    assert_directory './roro/containers'
    assert_directory './roro/smart.env'
  end

  def assert_roro_containers(*containers)
    assert_directory './roro/containers/pistil'
    assert_directory './roro/containers/stamen'
    assert_directory './roro/containers/database'
  end

  def assert_roro_environments(*environments); end

  def assert_roro_keys(*keys); end
end
