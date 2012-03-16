module BrowserShooter::Commander
  def self.execute( command, client, shots_path )
    BrowserShooter::Logger.log "command: #{command}"

    if( command.split[0].strip == "shot" )
      sufix = command.split[1] ? command.split[1].strip : nil

      BrowserShooter::Commander.shot(
        client,
        shots_path,
        sufix
      )

    elsif( command.split[0].strip == "shot_system" )
      sufix = command.split[1] ? command.split[1].strip : nil

      BrowserShooter::Commander.shot_system(
        client,
        shots_path,
        sufix
      )

    elsif( command.split[0].strip == "pause" )
      BrowserShooter::Commander.pause( command.split[1].strip.to_i )

    elsif( command.split[0].strip == "wait_for_element" )
      params = command.match /wait_for_element "(.*)"\s?,\s?(\d*)/

      BrowserShooter::Commander.wait_for_element(
        client,
        params[1],
        params[2].to_i
      )

    elsif( command.split[0].strip == "type" )
      params = command.match /type "(.*)"\s?,\s?"(.*)"/

      BrowserShooter::Commander.type(
        client,
        params[1],
        params[2]
      )

    elsif( command.split[0].strip == "click" )
      params = command.match /click "(.*)"/
      BrowserShooter::Commander.click(
        client,
        params[1]
      )

    else
      eval "client.#{command}"

    end
  end

  def self.wrapper_execute( command, client, shots_path )
    result = {
      :time     => Time.now.to_i,
      :command  => command
    }

    begin
      message =
        BrowserShooter::Commander.execute(
          command,
          client,
          shots_path
        )

      result.merge!(
        :success => true,
        :message => message
      )

    rescue Exception => e
      BrowserShooter::Logger.log "ERROR: #{e.message}"

      result.merge!(
        :success  => false,
        :message  => e.message
      )

    end

    return result
  end

  def self.shot( client, path, sufix = nil )
    sufix = timestamp unless sufix
    path  = "#{path}_#{sufix}.png"

    BrowserShooter::Logger.log "shooting in '#{path}'"
    client.save_screenshot path

    return path
  end

  # FIXME: Not supported in WebDriver
  # def self.shot_system( client, path, sufix = timestamp )
  #   sufix = timestamp unless sufix
  #   path  = "#{path}_#{sufix}.system.png"

  #   BrowserShooter::Logger.log "shooting system in '#{path}'"

  #   File.open( path, "wb" ) do |f|
  #     f.write( Base64.decode64( client.capture_screenshot_to_string ) )
  #   end

  #   return path
  # end

  def self.wait_for_element( client, css_selector, timeout )
    wait = Selenium::WebDriver::Wait.new( :timeout => timeout )

    wait.until do
      client.find_element( "css", css_selector )
    end
  end

  def self.click( client, css_selector )
    client.find_element( "css", css_selector ).click
  end

  def self.type( client, css_selector, text )
    client.find_element( "css", css_selector ).send_keys( text )
  end

  def self.pause( seconds )
    BrowserShooter::Logger.log "pausing #{seconds} seconds"
    Kernel.sleep seconds

    return "#{seconds} seconds later..."
  end

  def self.timestamp
    Time.now.to_i
  end
end
