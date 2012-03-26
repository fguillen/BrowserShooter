require_relative "../test_helper"

class BasicsTest < Test::Unit::TestCase
  def setup
    @driver       = mock()
    @browser      = mock()
    @output_path  = "output_path"

    @command_executor =
      BrowserShooter::Commands::Base.new(
        @driver,
        @browser,
        @output_path
      )
  end

  def test_wait_for_element
    wait = mock()

    Selenium::WebDriver::Wait.expects( :new ).with( :timeout => 10 ).returns( wait )
    wait.expects( :until ).yields
    @driver.expects( :find_element ).with( "css", "css_selector" )

    @command_executor.wait_for_element( "css_selector", 10 )
  end

  def test_click
    element = mock()

    @driver.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :click )

    @command_executor.click( "css_selector" )
  end

  def test_type
    element = mock()

    @driver.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :send_keys ).with( "message" )

    @command_executor.type( "css_selector", "message" )
  end

  def test_pause
    Kernel.expects( :sleep ).with( 1 )
    @command_executor.pause( 1 )
  end
end
