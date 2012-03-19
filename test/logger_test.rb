require_relative "test_helper"

class LoggerTest < Test::Unit::TestCase
  def test_verbose
    BrowserShooter::Logger.verbose = true
    assert_equal( true, BrowserShooter::Logger.verbose )

    BrowserShooter::Logger.verbose = false
    assert_equal( false, BrowserShooter::Logger.verbose )
  end

  def test_log_when_verbose
    BrowserShooter::Logger.unstub( :log )
    Kernel.expects( :puts )

    BrowserShooter::Logger.verbose = true
    BrowserShooter::Logger.log( "message" )
  end

  def test_log_when_no_verbose
    BrowserShooter::Logger.unstub( :log )
    Kernel.expects( :puts ).never

    BrowserShooter::Logger.verbose = false
    BrowserShooter::Logger.log( "message" )
  end
end