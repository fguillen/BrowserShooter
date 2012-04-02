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
    BrowserShooter::Configurator.stubs( :setup_output_path )

    opts = {}

    config_mock = mock()
    BrowserShooter::Configurator.expects( :new ).with( opts ).returns( config_mock )

    config_mock.stubs( :[] ).returns( "config_value" )
    config_mock.expects( :suites ).returns( [@suite1] )

    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test1, @browser1, config_mock )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test1, @browser2, config_mock )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test2, @browser1, config_mock )
    BrowserShooter::Base.expects( :run_test ).with( @suite1, @test2, @browser2, config_mock )

    BrowserShooter::Base.new( opts ).run
  end

  def test_run_test
    expected_opts = {
      :url                    => "url1",
      :desired_capabilities   => "type1".to_sym
    }

    config = {
      "output_path" => "output_path",
      "timeout"    => 66
    }

    timeouts_mock = mock()
    manage_mock   = mock()
    driver_mock   = mock()

    driver_mock.stubs( :manage ).returns( manage_mock )
    manage_mock.stubs( :timeouts ).returns( timeouts_mock )

    timeouts_mock.expects( :implicit_wait= ).with( 66 )
    driver_mock.expects( :quit )
    Selenium::WebDriver.expects( :for ).with( :remote, expected_opts ).returns( driver_mock )
    BrowserShooter::Commander.expects( :script ).with( @test1.commands, driver_mock, @browser1, "output_path/suite1/test1/browser1" ).returns( "log1" )
    BrowserShooter::LogExporter.expects( :export ).with( "log1", "output_path/suite1/test1/browser1/logs" )

    BrowserShooter::Base.run_test( @suite1, @test1, @browser1, config )
  end
end