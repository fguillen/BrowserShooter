module BrowserShooter
  module Logger
    extend self

    attr_accessor :verbose

    def log( message, force = verbose )
      if force
        Kernel.puts "[BrowserShooter #{Time.now.strftime( "%F %T" )}] #{message}"
      end
    end

  end
end