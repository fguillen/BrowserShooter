class BrowserShooter
  module LogExporter
    def self.export( logs, path, format )
      BrowserShooter::Logger.log "Exporting '#{format}' logs to #{path}"
      send(:"export_to_#{format}", logs, path )
    end

    def self.export_to_json( logs, path )
      File.open( "#{path}.json", "w" ) do |f|
        f.write JSON.pretty_generate( logs )
      end
    end

    def self.export_to_csv( logs, path )
      logs.each do |script_name, results|
        _path = File.expand_path "#{path}/#{script_name}.csv"

        File.open( _path, "w" ) do |f|
          f.puts results.first.keys.join( " | " )

          results.each do |result|
            f.puts result.values.join( " | " )
          end
        end
      end
    end
  end
end