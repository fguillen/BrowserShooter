require_relative "test_helper"

class DriverTest < Test::Unit::TestCase

  def test_run_script_on_browser
    browser = {
      "name"    => "browser-name",
      "host"    => "browser-host",
      "port"    => "browser-port",
      "browser" => "browser-browser"
    }

    script = {
      "name"      => "script-name",
      "url"       => "script-url",
      "commands"  => "one\ntwo\nthree"
    }

    expected_opts = {
      :host     => "browser-host",
      :port     => "browser-port",
      :browser  => "browser-browser",
      :url      => "script-url",
      :timeout_in_seconds => 40
    }

    client = Object.new
    client.expects( :start_new_browser_session )
    client.expects( :close_current_browser_session )

    Selenium::Client::Driver.expects( :new ).with( expected_opts ).returns( client )

    BrowserShooter::Commander.expects( :execute ).with( "one", client, "shoots-path/script-name_browser-name")
    BrowserShooter::Commander.expects( :execute ).with( "two", client, "shoots-path/script-name_browser-name")
    BrowserShooter::Commander.expects( :execute ).with( "three", client, "shoots-path/script-name_browser-name")

    BrowserShooter::Driver.run_script_on_browser(script, browser, "shoots-path")
  end
end
