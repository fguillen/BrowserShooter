require_relative "../test_helper"

class ScreenshotsTest < Test::Unit::TestCase
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

  def test_shot_with_sufix
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    @driver.expects( :save_screenshot ).with( "output_path/shots/sufix.png" )

    @command_executor.shot( "sufix" )
  end

  def test_shot_without_sufix
    BrowserShooter::Utils.stubs( :timestamp ).returns( "timestamp" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    @driver.expects( :save_screenshot ).with( "output_path/shots/timestamp.png" )

    @command_executor.shot
  end

  def test_shot_system_with_sufix
    shell_command = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/sufix.png'"

    @browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( shell_command ).returns( true )

    @command_executor.shot_system( "sufix" )
  end

  def test_shot_system_without_sufix
    shell_command = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/timestamp.png'"

    BrowserShooter::Utils.stubs( :timestamp ).returns( "timestamp" )
    @browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( shell_command ).returns( true )

    @command_executor.shot_system
  end

  def test_shot_system_with_error
    shell_command = "VBoxManage controlvm 'VMName' screenshotpng 'output_path/shots/sufix.png'"

    @browser.stubs( :vm ).returns( "VMName" )
    FileUtils.expects( :mkdir_p ).with( "output_path/shots" )
    Kernel.expects( :system ).with( shell_command ).returns( false )

    assert_raise( SystemCallError ) do
      @command_executor.shot_system( "sufix" )
    end
  end
end