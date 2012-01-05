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
    YAML.load_file( config_file_path )
  end

  def run
    prefix = Time.now.strftime("%Y%m%d%H%M%S")
    shoots_path = File.expand_path( "#{File.dirname(__FILE__)}/../#{config["shoots_path"]}/#{prefix}/" )
    FileUtils.mkdir_p( shoots_path )

    config["scripts"].each_value do |script|
      config["browsers"].each_value do |browser|
        BrowserShooter::Driver.run_script_on_browser(script, browser, shoots_path)
      end
    end
  end

end

