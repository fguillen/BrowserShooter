module BrowserShooter::Commander

  def self.script( commands, driver, browser, output_path )
    command_executor =
      BrowserShooter::Commands::Base.new(
        driver,
        browser,
        output_path
      )

    test_result =
      commands.map do |command|
        command_result =
          BrowserShooter::Commander.wrapper_execute(
            command_executor,
            command.strip
          )

        BrowserShooter::Logger.command_result( command_result )

        command_result
      end

    BrowserShooter::Logger.test_result( test_result )

    test_result
  end

  def self.wrapper_execute( command_executor, command )
    result = {
      :time     => Time.now.to_i,
      :command  => command
    }

    begin
      message =
        BrowserShooter::Commander.execute(
          command_executor,
          command
        )


      result.merge!(
        :success => true,
        :message => message
      )

    rescue Exception => e
      BrowserShooter::Logger.log "ERROR: #{e.message}"

      # puts "XXX: Exception"
      # puts e.backtrace.join( "\n" )

      result.merge!(
        :success  => false,
        :message  => e.message
      )

    end

    return result
  end

  def self.execute( command_executor, command )
    BrowserShooter::Logger.log "command: #{command}"
    command_name = command.split( /[\s\(]/ )[0].strip

    if( command_executor.respond_to?( command_name.to_sym ) )
      eval "command_executor.#{command}"
    else
      eval "command_executor.driver.#{command}"
    end
  end

end
