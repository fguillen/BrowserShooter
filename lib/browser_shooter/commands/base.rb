module BrowserShooter
  module Commands
    class Base
      attr_reader :driver, :browser, :output_path

      def initialize( driver, browser, output_path )
        @driver       = driver
        @browser      = browser
        @output_path  = output_path
      end

      def self.plug( _module )
        include( _module )
      end
    end
  end
end