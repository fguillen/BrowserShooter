require_relative "test_helper"

class ConfiguratorTest < Test::Unit::TestCase
  def test_load_config
    BrowserShooter::Configurator.expects( :timestamp ).returns( "timestamp" )
    FileUtils.expects( :mkdir_p ).with( "/shoots-path/timestamp" )
    FileUtils.expects( :mkdir ).with( "/shoots-path/timestamp/shots" )
    FileUtils.expects( :mkdir ).with( "/shoots-path/timestamp/logs" )

    config = BrowserShooter::Configurator.load_config( "#{FIXTURES}/config_simple.yml" )

    assert_equal( "/shoots-path/timestamp", config["output_path"] )
    assert_equal( "script-one", config["scripts"]["script-one"] )
    assert_equal( "browser-one", config["browsers"]["browser-one"] )
  end
end