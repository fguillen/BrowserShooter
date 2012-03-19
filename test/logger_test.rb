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

  def test_result_when_true
    test_result = { :success => true }
    Kernel.expects( :put ).with( "." )
    BrowserShooter::Logger.result( test_result )
  end

  def test_result_when_false
    test_result = { :success => false }
    Kernel.expects( :put ).with( "F" )
    BrowserShooter::Logger.result( test_result )
  end
end