require_relative "test_helper"

class CommanderTest < Test::Unit::TestCase
  def test_script
    commands = [
      "command1",
      "  command2 "
    ]

    BrowserShooter::Commands::Base.expects( :new ).with( "driver", "browser", "output_path" ).returns( "command_executor" )

    BrowserShooter::Commander.expects( :wrapper_execute ).with( "command_executor", "command1" ).returns( "result1" )
    BrowserShooter::Commander.expects( :wrapper_execute ).with( "command_executor", "command2" ).returns( "result2" )
    BrowserShooter::Logger.expects( :command_result ).twice
    BrowserShooter::Logger.expects( :test_result )

    result = BrowserShooter::Commander.script( commands, "driver", "browser", "output_path" )

    assert_equal( ["result1", "result2"], result )
  end

  def test_wrapper_execute
    BrowserShooter::Commander.expects( :execute ).with( "command_executor", "command" ).returns( "message" )
    result = BrowserShooter::Commander.wrapper_execute( "command_executor", "command" )

    assert_equal( "command", result[:command] )
    assert_equal( false, result[:time].nil? )
    assert_equal( true, result[:success] )
    assert_equal( "message", result[:message] )
  end

  def test_wrapper_execute_when_error
    BrowserShooter::Commander.expects( :execute ).with( "command_executor", "command" ).raises( Exception.new( "error" ) )
    result = BrowserShooter::Commander.wrapper_execute( "command_executor", "command" )

    assert_equal( "command", result[:command] )
    assert_equal( false, result[:time].nil? )
    assert_equal( false, result[:success] )
    assert_equal( "error", result[:message] )
  end

  def test_execute_in_command_executor
    command_executor = mock()

    command_executor.expects( :respond_to? ).with( :command_name ).returns( true )
    command_executor.expects( :command_name ).with( "arg1", "arg2" )

    BrowserShooter::Commander.execute( command_executor, "command_name 'arg1', 'arg2'" )
  end

  def test_execute_in_command_executor_command_with_params
    command_executor = mock()

    command_executor.expects( :respond_to? ).with( :command_name ).returns( true )
    command_executor.expects( :command_name ).with( "arg1", "arg2" )

    BrowserShooter::Commander.execute( command_executor, "command_name('arg1', 'arg2')" )
  end

  def test_execute_in_driver
    command_executor = mock()
    driver           = mock()

    command_executor.expects( :respond_to? ).with( :command_name ).returns( false )
    command_executor.expects( :driver ).returns( driver )
    driver.expects( :command_name ).with( "arg1", "arg2" )

    BrowserShooter::Commander.execute( command_executor, "command_name 'arg1', 'arg2'" )
  end
end