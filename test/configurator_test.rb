require_relative "test_helper"

class ConfiguratorTest < Test::Unit::TestCase
  def test_load_config
    BrowserShooter::Configurator.expects( :timestamp ).returns( "timestamp" )
    FileUtils.expects( :mkdir_p ).with( "/shoots-path/timestamp" )

    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config_simple.yml" )

    assert_equal( "/shoots-path/timestamp", config["shoots_path"] )
    assert_equal( "script-one", config["scripts"]["script-one"] )
    assert_equal( "browser-one", config["browsers"]["browser-one"] )
  end
end