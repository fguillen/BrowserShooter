require_relative "test_helper"

class DriverTest < Test::Unit::TestCase

  def test_run_script_on_browser

    browser = BrowserShooter::Models::Browser.new( "browser-name", "browser-url", "browser-type" )
    commands = ["command1", "command2"]

    expected_opts = {
      :url                    => "browser-url",
      :desired_capabilities   => "browser-type".to_sym
    }

    client = mock()
    client.expects( :quit )

    Selenium::WebDriver.expects( :for ).with( :remote, expected_opts ).returns( client )

    BrowserShooter::Commander.expects( :execute ).with( "command1", client, "output_path")
    BrowserShooter::Commander.expects( :execute ).with( "command2", client, "output_path")

    BrowserShooter::Driver.run_script_on_browser( commands, browser, "output_path" )
  end
end
