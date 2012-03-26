module BrowserShooter
  module Commands
    module Debug
      def try( ruby_code )
        eval ruby_code
      end

      def debug
        while( true )
          print "BrowserShooter > "
          line = STDIN.gets.chomp

          break if line == "exit"

          eval line
        end
      end
    end
  end
end

BrowserShooter::Commands::Base.plug( BrowserShooter::Commands::Debug )