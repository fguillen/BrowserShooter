module BrowserShooter
  module Logger
    extend self

    attr_accessor :verbose

    def log( message, force = verbose )
      if force
        Kernel.puts "[BrowserShooter #{Time.now.strftime( "%F %T" )}] #{message}"
      end
    end

    def command_result( command_result )
      Kernel.print "." if command_result[:success]
      Kernel.print "F" if !command_result[:success]
    end

    def test_result( test_result )
      Kernel.puts " (success)" if test_result.all? { |e| e[:success] }
      Kernel.puts " (fail)"    if !test_result.all? { |e| e[:success] }
    end

  end
end