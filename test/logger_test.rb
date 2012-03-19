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

  def test_command_result_when_true
    command_result = { :success => true }
    Kernel.expects( :print ).with( "." )
    BrowserShooter::Logger.command_result( command_result )
  end

  def test_command_result_when_false
    command_result = { :success => false }
    Kernel.expects( :print ).with( "F" )
    BrowserShooter::Logger.command_result( command_result )
  end

  def test_test_result_when_true
    test_result = [{ :success => true }]
    Kernel.expects( :puts ).with( " (success)" )
    BrowserShooter::Logger.test_result( test_result )
  end

  def test_test_result_when_false
    test_result = [{ :success => false }]
    Kernel.expects( :puts ).with( " (fail)" )
    BrowserShooter::Logger.test_result( test_result )
  end
end