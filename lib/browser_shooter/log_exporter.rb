module BrowserShooter
  module LogExporter
    def self.export( logs, logs_path, format = "csv" )
      logs_path = File.expand_path( "#{logs_path}/log.#{format}" )
      BrowserShooter::Logger.log "Exporting '#{format}' logs to #{logs_path}"
      FileUtils.mkdir_p( File.dirname( logs_path ) )

      send(:"export_to_#{format}", logs, logs_path )
    end

    def self.export_to_csv( logs, path )
      File.open( path, "w" ) do |f|
        f.puts "time | success | command | message"

        logs.each do |result|
          line = "#{result[:time]} | #{result[:success]} | #{result[:command]} | #{result[:message]}".gsub( "\n", " - " )
          f.puts line
        end
      end
    end
  end
end