require_relative "test_helper"

class DriverTest < Test::Unit::TestCase

  def test_run_script_on_browser
    browser = {
      "name"    => "browser-name",
      "url"     => "url",
      "browser" => "browser-browser"
    }

    script = {
      "name"      => "script-name",
      "url"       => "script-url",
      "commands"  => "one\ntwo\nthree"
    }

    expected_opts = {
      :url                    => "url",
      :desired_capabilities   => "browser-browser".to_sym
    }

    client = mock()
    client.expects( :quit )

    Selenium::WebDriver.expects( :for ).with( :remote, expected_opts ).returns( client )

    BrowserShooter::Commander.expects( :execute ).with( "one", client, "shoots-path/script-name_browser-name")
    BrowserShooter::Commander.expects( :execute ).with( "two", client, "shoots-path/script-name_browser-name")
    BrowserShooter::Commander.expects( :execute ).with( "three", client, "shoots-path/script-name_browser-name")

    BrowserShooter::Driver.run_script_on_browser(script, browser, "shoots-path")
  end
end
