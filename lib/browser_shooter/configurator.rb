module BrowserShooter::Configurator
  def self.execution_tree
  end

  def self.load_config( config_file_path )
    config = {
      "output_path" => "~/browser_shooter",
      "logs_format" => "csv"
    }

    config.merge! YAML.load_file( config_file_path )

    config["output_path"] = set_up_output_path( config["output_path"] )

    config
  end

  def self.set_up_output_path( output_path )
    output_path = File.expand_path( "#{output_path}/#{timestamp}" )
    BrowserShooter::Logger.log( "output_path: #{output_path}" )

    FileUtils.mkdir_p( output_path )
    FileUtils.mkdir( "#{output_path}/shots" )
    FileUtils.mkdir( "#{output_path}/logs" )

    output_path
  end

  def self.timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end
end
