module BrowserShooter
  module Logger
    extend self

    attr_accessor :verbose

    def log( message )
      if verbose
        Kernel.puts "[BrowserShooter #{Time.now.strftime( "%F %T" )}] #{message}"
      end
    end
  end
end