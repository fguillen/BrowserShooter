module BrowserShooter
  module LogExporter
    def self.export( logs, logs_path, format )
      logs_path = File.expand_path( "#{logs_path}/log.#{format}" )
      BrowserShooter::Logger.log "Exporting '#{format}' logs to #{logs_path}"
      FileUtils.mkdir_p( File.dirname( logs_path ) )

      send(:"export_to_#{format}", logs, logs_path )
    end

    def self.export_to_csv( logs, path )
      File.open( path, "w" ) do |f|
        f.puts logs.first.keys.join( " | " )

        logs.each do |result|
          f.puts result.values.join( " | " )
        end
      end
    end
  end
end