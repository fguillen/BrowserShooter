require_relative "./browser_shooter/version"
require_relative "./browser_shooter/logger"
require_relative "./browser_shooter/driver"
require_relative "./browser_shooter/commander"

require "selenium-webdriver"
require "selenium-client"
require "yaml"

class BrowserShooter
  attr_reader :config

  def initialize( config_file_path )
    @config = load_config( config_file_path )
  end

  def load_config( config_file_path )
    config = YAML.load_file( config_file_path )
    config = set_up_shoots_path( config )

    config
  end

  def run
    config["scripts"].each_value do |script|
      config["browsers"].each_value do |browser|
        BrowserShooter::Driver.run_script_on_browser(script, browser, config["shoots_path"])
      end
    end
  end

  def set_up_shoots_path( config )
    if( !config["shoots_path"].match( /^\// ) )
      config["shoots_path"] = File.expand_path( "#{File.dirname(__FILE__)}/../#{config["shoots_path"]}" )
    end
    config["shoots_path"] = "#{config["shoots_path"]}/#{Time.now.strftime("%Y%m%d%H%M%S")}"

    BrowserShooter::Logger.log( "shoots_path: #{config["shoots_path"]}" )

    FileUtils.mkdir_p( config["shoots_path"] )

    config
  end

end

