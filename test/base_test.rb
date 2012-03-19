require_relative "test_helper"

class BaseTest < Test::Unit::TestCase
  def setup
    super

    @test1     = BrowserShooter::Models::Test.new( "test1", ["command1", "command2"] )
    @test2     = BrowserShooter::Models::Test.new( "test2", ["command3"] )
    @browser1  = BrowserShooter::Models::Browser.new( "browser1", "url1", "type1" )
    @browser2  = BrowserShooter::Models::Browser.new( "browser2", "url2", "type2" )
    @suite1    = BrowserShooter::Models::Suite.new( "suite1", [@test1, @test2], [@browser1, @browser2] )
  end

  def test_initialize
    assert_equal( "opts", BrowserShooter::Base.new( "opts" ).opts )
  end

  def test_run
    BrowserShooter::Configurator.stubs( :set_up_output_path )

    opts = {}

    config_mock = mock()
    BrowserShooter::Configurator.expects( :new ).with( opts ).returns( config_mock )

    config_mock.stubs( :[] ).returns( "config_value" )
    config_mock.expects( :suites ).returns( [@suite1] )

    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test1, @browser1, "config_value" )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test1, @browser2, "config_value" )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test2, @browser1, "config_value" )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test2, @browser2, "config_value" )

    BrowserShooter::Base.new( opts ).run
  end

  def test_run_script
    expected_opts = {
      :url                    => "url1",
      :desired_capabilities   => "type1".to_sym
    }

    driver = mock()
    driver.expects( :quit )
    Selenium::WebDriver.expects( :for ).with( :remote, expected_opts ).returns( driver )
    BrowserShooter::Commander.expects( :script ).with( @test1.commands, driver, "output_path/suite1/test1/browser1" ).returns( "log1" )
    BrowserShooter::LogExporter.expects( :export ).with( "log1", "output_path/suite1/test1/browser1/logs" )

    BrowserShooter::Base.run_test( @suite1, @test1, @browser1, "output_path" )
  end
end