module BrowserShooter
  module Commands
    module Basic
      def wait_for_element( css_selector, timeout )
        wait = Selenium::WebDriver::Wait.new( :timeout => timeout )

        wait.until do
          driver.find_element( "css", css_selector )
        end
      end

      def click( css_selector )
        driver.find_element( "css", css_selector ).click
      end

      def type( css_selector, text )
        driver.find_element( "css", css_selector ).send_keys( text )
      end

      def pause( seconds )
        BrowserShooter::Logger.log "pausing #{seconds} seconds"
        Kernel.sleep seconds

        return "#{seconds} seconds later..."
      end

    end
  end
end
BrowserShooter::Commands::Base.plug( BrowserShooter::Commands::Basic )