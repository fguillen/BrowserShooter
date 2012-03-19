require_relative "test_helper"

class CommanderTest < Test::Unit::TestCase
  def test_execute_when_shot_with_sufix
    BrowserShooter::Commander.expects( :shot ).with( "client", "shoot-path", "sufix" )
    BrowserShooter::Commander.execute( "shot sufix", "client", "shoot-path" )
  end

  def test_execute_when_shot_without_sufix
    BrowserShooter::Commander.expects( :shot ).with( "client", "shoot-path", nil )
    BrowserShooter::Commander.execute( "shot", "client", "shoot-path" )
  end

  def test_execute_when_pause
    BrowserShooter::Commander.expects( :pause ).with( 10 )
    BrowserShooter::Commander.execute( "pause 10", "client", "shoot-path" )
  end

  def test_execute_when_wait_for_element
    BrowserShooter::Commander.expects( :wait_for_element ).with( "client", "css_selector", 10 )
    BrowserShooter::Commander.execute( "wait_for_element \"css_selector\", 10", "client", nil )
  end

  def test_execute_when_click
    BrowserShooter::Commander.expects( :click ).with( "client", "css_selector" )
    BrowserShooter::Commander.execute( "click \"css_selector\"", "client", nil )
  end

  def test_execute_when_type
    BrowserShooter::Commander.expects( :type ).with( "client", "css_selector", "message a b" )
    BrowserShooter::Commander.execute( "type \"css_selector\", \"message a b\"", "client", nil )
  end

  def test_shot_with_sufix
    in_tmpdir do |tmpdir|
      client      = mock()
      output_path = tmpdir

      FileUtils.expects( :mkdir_p ).with( "#{output_path}/shots" )
      client.expects( :save_screenshot ).with( "#{output_path}/shots/sufix.png" )

      BrowserShooter::Commander.shot( client, output_path, "sufix" )
    end
  end

  def test_shot_without_sufix
    BrowserShooter::Commander.stubs( :timestamp ).returns( "timestamp" )

    in_tmpdir do |tmpdir|
      client      = mock()
      output_path = tmpdir

      FileUtils.expects( :mkdir_p ).with( "#{output_path}/shots" )
      client.expects( :save_screenshot ).with( "#{output_path}/shots/timestamp.png" )

      BrowserShooter::Commander.shot( client, output_path, nil )
    end
  end

  def test_wait_for_element
    wait    = mock()
    client  = mock()

    Selenium::WebDriver::Wait.expects( :new ).with( :timeout => 10 ).returns( wait )
    wait.expects( :until ).yields
    client.expects( :find_element ).with( "css", "css_selector" )

    BrowserShooter::Commander.wait_for_element( client, "css_selector", 10 )
  end

  def test_click
    client  = mock()
    element = mock()

    client.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :click )

    BrowserShooter::Commander.click( client, "css_selector" )
  end

  def test_type
    client  = mock()
    element = mock()

    client.expects( :find_element ).with( "css", "css_selector" ).returns( element )
    element.expects( :send_keys ).with( "message" )

    BrowserShooter::Commander.type( client, "css_selector", "message" )
  end

  def test_pause
    Kernel.expects( :sleep ).with( 1 )
    BrowserShooter::Commander.pause( 1 )
  end
end