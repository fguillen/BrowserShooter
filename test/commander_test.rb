require_relative "test_helper"

class CommanderTest < Test::Unit::TestCase
  def test_script
    commands = [
      "command1",
      "  command2 "
    ]

    BrowserShooter::Commander.expects( :wrapper_execute ).with( "command1", "driver", "browser", "output_path" ).returns( "result1" )
    BrowserShooter::Commander.expects( :wrapper_execute ).with( "command2", "driver", "browser", "output_path" ).returns( "result2" )
    BrowserShooter::Logger.expects( :command_result ).twice
    BrowserShooter::Logger.expects( :test_result )

    result = BrowserShooter::Commander.script( commands, "driver", "browser", "output_path" )

    assert_equal( ["result1", "result2"], result )
  end

  def test_wrapper_execute
    BrowserShooter::Commander.expects( :execute ).with( "command", "driver", "browser", "output_path" ).returns( "message" )
    result = BrowserShooter::Commander.wrapper_execute( "command", "driver", "browser", "output_path" )

    assert_equal( "command", result[:command] )
    assert_equal( false, result[:time].nil? )
    assert_equal( true, result[:success] )
    assert_equal( "message", result[:message] )
  end

  def test_wrapper_execute_when_error
    BrowserShooter::Commander.expects( :execute ).with( "command", "driver", "browser", "output_path" ).raises( Exception.new( "error" ) )
    result = BrowserShooter::Commander.wrapper_execute( "command", "driver", "browser", "output_path" )

    assert_equal( "command", result[:command] )
    assert_equal( false, result[:time].nil? )
    assert_equal( false, result[:success] )
    assert_equal( "error", result[:message] )
  end

  def test_execute_when_shot_with_sufix
    BrowserShooter::Commander.expects( :shot ).with( "driver", "shoot-path", "sufix" )
    BrowserShooter::Commander.execute( "shot sufix", "driver", "browser", "shoot-path" )
  end

  def test_execute_when_shot_without_sufix
    BrowserShooter::Commander.expects( :shot ).with( "driver", "shoot-path", nil )
    BrowserShooter::Commander.execute( "shot", "driver", "browser", "shoot-path" )
  end

  def test_execute_when_shot_system_with_sufix
    BrowserShooter::Commander.expects( :shot_system ).with( "driver", "browser", "shoot-path", "sufix" )
    BrowserShooter::Commander.execute( "shot_system sufix", "driver", "browser", "shoot-path" )
  end

  def test_execute_when_shot_system_without_sufix
    BrowserShooter::Commander.expects( :shot_system ).with( "driver", "browser", "shoot-path", nil )
    BrowserShooter::Commander.execute( "shot_system", "driver", "browser", "shoot-path" )
  end

  def test_execute_when_pause
    BrowserShooter::Commander.expects( :pause ).with( 10 )
    BrowserShooter::Commander.execute( "pause 10", "driver", "browser", "shoot-path" )
  end

  def test_execute_when_wait_for_element
    BrowserShooter::Commander.expects( :wait_for_element ).with( "driver", "css_selector", 10 )
    BrowserShooter::Commander.execute( "wait_for_element \"css_selector\", 10", "driver", "browser", nil )
  end

  def test_execute_when_click
    BrowserShooter::Commander.expects( :click ).with( "driver", "css_selector" )
    BrowserShooter::Commander.execute( "click \"css_selector\"", "driver", "browser", nil )
  end

  def test_execute_when_type
    BrowserShooter::Commander.expects( :type ).with( "driver", "css_selector", "message a b" )
    BrowserShooter::Commander.execute( "type \"css_selector\", \"message a b\"", "driver", "browser", nil )
  end

  def test_shot_with_sufix
    driver = mock()

    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    driver.expects( :save_screenshot ).with( "output_path/shots/sufix.png" )

    BrowserShooter::Commander.shot( driver, "output_path", "sufix" )
  end

  def test_shot_without_sufix
    BrowserShooter::Commander.stubs( :timestamp ).returns( "timestamp" )

    driver = mock()

    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    driver.expects( :save_screenshot ).with( "output_path/shots/timestamp.png" )

    BrowserShooter::Commander.shot( driver, "output_path", nil )
  end

  def test_shot_system_with_sufix
    browser  = mock()
    command  = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/sufix.png'"

    browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( command ).returns( true )

    BrowserShooter::Commander.shot_system( "driver", browser, "output_path", "sufix" )
  end

  def test_shot_system_without_sufix
    browser  = mock()
    command  = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/timestamp.png'"

    BrowserShooter::Commander.stubs( :timestamp ).returns( "timestamp" )
    browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( command ).returns( true )

    BrowserShooter::Commander.shot_system( "driver", browser, "output_path" )
  end

  def test_shot_system_with_error
    browser  = mock()
    command  = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/sufix.png'"

    browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( command ).returns( false )

    assert_raise( SystemCallError ) do
      BrowserShooter::Commander.shot_system( "driver", browser, "output_path", "sufix" )
    end
  end

  def test_wait_for_element
    wait    = mock()
    driver  = mock()

    Selenium::WebDriver::Wait.expects( :new ).with( :timeout => 10 ).returns( wait )
    wait.expects( :until ).yields
    driver.expects( :find_element ).with( "css", "css_selector" )

    BrowserShooter::Commander.wait_for_element( driver, "css_selector", 10 )
  end

  def test_click
    driver  = mock()
    element = mock()

    driver.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :click )

    BrowserShooter::Commander.click( driver, "css_selector" )
  end

  def test_type
    driver  = mock()
    element = mock()

    driver.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :send_keys ).with( "message" )

    BrowserShooter::Commander.type( driver, "css_selector", "message" )
  end

  def test_pause
    Kernel.expects( :sleep ).with( 1 )
    BrowserShooter::Commander.pause( 1 )
  end
end