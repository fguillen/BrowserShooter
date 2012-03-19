module BrowserShooter
  module Logger
    extend self

    attr_accessor :verbose

    def log( message, force = verbose )
      if force
        Kernel.puts "[BrowserShooter #{Time.now.strftime( "%F %T" )}] #{message}"
      end
    end

    def result( test_result )
      Kernel.put "." if test_result[:success]
      Kernel.put "F" if !test_result[:success]
    end

  end
end