class BrowserShooter
  module Commander
    def self.execute( command, client, shoot_path )
      BrowserShooter::Logger.log "command: #{command}"

      if( command.split[0].strip == "shot" )
        sufix = command.split[1] ? command.split[1].strip : nil

        BrowserShooter::Commander.shot(
          client,
          shoot_path,
          sufix
        )

      elsif( command.split[0].strip == "pause" )
        BrowserShooter::Commander.pause( command.split[1].strip.to_i )

      else
        eval "client.#{command}"

      end
    end

    def self.shot( client, path, sufix = nil )
      sufix = sufix.nil? ? "" : "_#{sufix}"
      path  = "#{path}#{sufix}.png"

      BrowserShooter::Logger.log "shooting in '#{path}'"

      File.open( path, "wb" ) do |f|
        f.write( Base64.decode64( client.capture_entire_page_screenshot_to_string( "" ) ) )
      end
    end

    def self.pause( seconds )
      BrowserShooter::Logger.log "pausing #{seconds} seconds"
      sleep seconds
    end
  end
end