require_relative "test_helper"

class BrowserScreenshotTest < Test::Unit::TestCase
  def test_initialize
    assert_equal( "filepath", BrowserShooter.new( "filepath" ).config_file_path )
  end

  def test_run
    config_file_path = "#{FIXTURES}/config_simple.yml"
    BrowserShooter::Configurator.expects( :load_config ).with( config_file_path ).returns( YAML.load_file( config_file_path ) )

    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-one", "browser-one", "/shoots-path" )
    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-one", "browser-two", "/shoots-path" )
    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-one", "browser-three", "/shoots-path" )
    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-two", "browser-one", "/shoots-path" )
    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-two", "browser-two", "/shoots-path" )
    BrowserShooter::Driver.expects( :run_script_on_browser).with( "script-two", "browser-three", "/shoots-path" )

    BrowserShooter::Util.expects( :export_logs_to_csv )

    BrowserShooter.new( config_file_path ).run
  end
end