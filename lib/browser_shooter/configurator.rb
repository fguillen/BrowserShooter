class BrowserShooter
  module Configurator
    def self.load_config( config_file_path )
      config = YAML.load_file( config_file_path )
      config["shoots_path"] = set_up_shoots_path( config["shoots_path"] )

      config
    end

    def self.set_up_shoots_path( shoots_path )
      shoots_path = File.expand_path( "#{shoots_path}/#{timestamp}" )
      BrowserShooter::Logger.log( "shoots_path: #{shoots_path}" )

      FileUtils.mkdir_p( shoots_path )

      shoots_path
    end

    def self.timestamp
      Time.now.strftime("%Y%m%d%H%M%S")
    end
  end
end