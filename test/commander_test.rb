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

  def test_execute_when_shot_system_with_sufix
    BrowserShooter::Commander.expects( :shot_system ).with( "client", "shoot-path", "sufix" )
    BrowserShooter::Commander.execute( "shot_system sufix", "client", "shoot-path" )
  end

  def test_execute_when_shot_system_without_sufix
    BrowserShooter::Commander.expects( :shot_system ).with( "client", "shoot-path", nil )
    BrowserShooter::Commander.execute( "shot_system", "client", "shoot-path" )
  end

  def test_execute_when_shot_pause
    BrowserShooter::Commander.expects( :pause ).with( 10 )
    BrowserShooter::Commander.execute( "pause 10", "client", "shoot-path" )
  end

  def test_shot_with_sufix
    in_tmpdir do |tmpdir|
      client = stub( :capture_entire_page_screenshot_to_string => read_fixture( "screenshot.base64" ) )
      path = "#{tmpdir}/myfile"

      BrowserShooter::Commander.shot( client, path, "sufix" )

      assert_equal(
       Digest::MD5.hexdigest( Base64.decode64( read_fixture( "screenshot.base64" ) ) ),
       Digest::MD5.hexdigest( File.read( "#{path}_sufix.png" ) )
      )
    end
  end

  def test_shot_without_sufix
    in_tmpdir do |tmpdir|
      client = stub( :capture_entire_page_screenshot_to_string => read_fixture( "screenshot.base64" ) )
      path = "#{tmpdir}/myfile"

      BrowserShooter::Commander.shot( client, path, nil )

      assert_equal(
       Digest::MD5.hexdigest( Base64.decode64( read_fixture( "screenshot.base64" ) ) ),
       Digest::MD5.hexdigest( File.read( "#{path}.png" ) )
      )
    end
  end

  def test_shot_system_with_sufix
    in_tmpdir do |tmpdir|
      client = stub( :capture_screenshot_to_string => read_fixture( "screenshot.base64" ) )
      path = "#{tmpdir}/myfile"

      BrowserShooter::Commander.shot_system( client, path, "sufix" )

      assert_equal(
       Digest::MD5.hexdigest( Base64.decode64( read_fixture( "screenshot.base64" ) ) ),
       Digest::MD5.hexdigest( File.read( "#{path}_sufix.system.png" ) )
      )
    end
  end

  def test_shot_system_without_sufix
    in_tmpdir do |tmpdir|
      client = stub( :capture_screenshot_to_string => read_fixture( "screenshot.base64" ) )
      path = "#{tmpdir}/myfile"

      BrowserShooter::Commander.shot_system( client, path, nil )

      assert_equal(
       Digest::MD5.hexdigest( Base64.decode64( read_fixture( "screenshot.base64" ) ) ),
       Digest::MD5.hexdigest( File.read( "#{path}.system.png" ) )
      )
    end
  end

  def test_pause
    Kernel.expects( :sleep ).with( 1 )
    BrowserShooter::Commander.pause( 1 )
  end
end