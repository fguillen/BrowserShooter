module BrowserShooter
  module Logger
    def self.log( message )
      puts "[BrowserShooter #{Time.now.strftime( "%F %T" )}] #{message}"
    end
  end
end