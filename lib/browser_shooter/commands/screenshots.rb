module BrowserShooter
  module Commands
    module Screenshots

      def shot( sufix = nil )
        sufix     = BrowserShooter::Utils.timestamp unless sufix
        shot_path = "#{output_path}/shots/#{sufix}.png"

        BrowserShooter::Logger.log "shooting in '#{shot_path}'"

        FileUtils.mkdir_p( File.dirname( shot_path ) )
        driver.save_screenshot( shot_path )

        return shot_path
      end

      def shot_system( sufix = nil )
        sufix     = BrowserShooter::Utils.timestamp unless sufix
        shot_path = "#{output_path}/shots/#{sufix}.png"

        BrowserShooter::Logger.log "shooting system in '#{shot_path}'"

        FileUtils.mkdir_p( File.dirname( shot_path ) )

        command = "VBoxManage controlvm '#{browser.vm}' screenshotpng '#{shot_path}'"
        success = Kernel.system( command )

        if( !success )
          raise SystemCallError, "Shoot system command [#{command}] returns error: '#{$?}'"
        end

        return shot_path
      end

    end
  end
end
BrowserShooter::Commands::Base.plug( BrowserShooter::Commands::Screenshots )