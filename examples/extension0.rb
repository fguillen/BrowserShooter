module Extension0

  def log( arg1, arg2 )
    puts "This is the log extension method"
    puts "arg1: #{arg1}"
    puts "arg2: #{arg2}"
    puts "driver: #{driver}"
    puts "browser: #{browser}"
    puts "output_path: #{output_path}"
  end

end
BrowserShooter::Commands::Base.plug( Extension0 )