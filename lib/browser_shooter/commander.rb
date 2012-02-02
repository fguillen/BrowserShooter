class BrowserShooter
  module Commander
    def self.execute( command, client, output_path )
      BrowserShooter::Logger.log "command: #{command}"

      if( command.split[0].strip == "shot" )
        sufix = command.split[1] ? command.split[1].strip : nil

        BrowserShooter::Commander.shot(
          client,
          output_path,
          sufix
        )

      elsif( command.split[0].strip == "shot_system" )
        sufix = command.split[1] ? command.split[1].strip : nil

        BrowserShooter::Commander.shot_system(
          client,
          output_path,
          sufix
        )

      elsif( command.split[0].strip == "pause" )
        BrowserShooter::Commander.pause( command.split[1].strip.to_i )

      else
        eval "client.#{command}"

      end
    end

    def self.wrapper_execute( command, client, output_path )
      result = {
        :time     => Time.now.to_i,
        :command  => command
      }

      begin
        message =
          BrowserShooter::Commander.execute(
            command,
            client,
            output_path
          )

        result.merge!(
          :success => true,
          :message => message
        )

      rescue Exception => e
        result.merge!(
          :success  => false,
          :message  => e.message
        )

      end

      return result
    end

    def self.shot( client, path, sufix = nil )
      sufix = "_#{sufix}" unless sufix.nil?
      path  = "#{path}#{sufix}.png"

      BrowserShooter::Logger.log "shooting in '#{path}'"

      File.open( path, "wb" ) do |f|
        f.write( Base64.decode64( client.capture_entire_page_screenshot_to_string( "" ) ) )
      end

      return path
    end

    def self.shot_system( client, path, sufix = nil )
      sufix = "_#{sufix}" unless sufix.nil?
      path  = "#{path}#{sufix}.system.png"

      BrowserShooter::Logger.log "shooting system in '#{path}'"

      File.open( path, "wb" ) do |f|
        f.write( Base64.decode64( client.capture_screenshot_to_string ) )
      end

      return path
    end

    def self.pause( seconds )
      BrowserShooter::Logger.log "pausing #{seconds} seconds"
      Kernel.sleep seconds

      return "#{seconds} later..."
    end
  end
end