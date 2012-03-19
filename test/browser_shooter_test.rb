require_relative "test_helper"

class BrowserShooterTest < Test::Unit::TestCase
  def test_initialize
    assert_equal( "opts", BrowserShooter.new( "opts" ).opts )
  end

  def test_run
    BrowserShooter::Configurator.stubs( :set_up_output_path )

    opts = { :config_file => "#{FIXTURES}/config_simple.yml" }

    test1     = BrowserShooter::Models::Test.new( "test1", ["command1", "command2"] )
    test2     = BrowserShooter::Models::Test.new( "test2", ["command3"] )
    browser1  = BrowserShooter::Models::Browser.new( "browser1", "url1", "type1" )
    browser2  = BrowserShooter::Models::Browser.new( "browser2", "url2", "type2" )
    suite1    = BrowserShooter::Models::Suite.new( "suite1", [test1, test2], [browser1, browser2] )

    config_mock = mock()
    BrowserShooter::Configurator.expects( :new ).with( opts ).returns( config_mock )

    config_mock.stubs( :[] ).returns( "config_value" )
    config_mock.expects( :suites ).returns( [suite1] )

    BrowserShooter::Driver.expects( :run_script ).with( test1.commands, browser1, "config_value/suite1/test1/browser1" ).returns( "log1" )
    BrowserShooter::Driver.expects( :run_script ).with( test1.commands, browser2, "config_value/suite1/test1/browser2" ).returns( "log2" )
    BrowserShooter::Driver.expects( :run_script ).with( test2.commands, browser1, "config_value/suite1/test2/browser1" ).returns( "log3" )
    BrowserShooter::Driver.expects( :run_script ).with( test2.commands, browser2, "config_value/suite1/test2/browser2" ).returns( "log4" )

    BrowserShooter::LogExporter.expects( :export ).with( "log1", "config_value/suite1/test1/browser1/logs", "config_value" )
    BrowserShooter::LogExporter.expects( :export ).with( "log2", "config_value/suite1/test1/browser2/logs", "config_value" )
    BrowserShooter::LogExporter.expects( :export ).with( "log3", "config_value/suite1/test2/browser1/logs", "config_value" )
    BrowserShooter::LogExporter.expects( :export ).with( "log4", "config_value/suite1/test2/browser2/logs", "config_value" )

    BrowserShooter.new( opts ).run
  end
end